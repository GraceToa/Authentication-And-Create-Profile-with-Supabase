//
//  UpdateProfileUseCase.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 22/7/25.
//

import SwiftUI

/// Updates a user profile and handles avatar replacement logic.
/// Implements `UpdateProfileUseCaseProtocol` coordinating repository, uploader, and cache.
/// Ensures cleanup of old avatars and rollback on upload failure.

class UpdateProfileUseCase: UpdateProfileUseCaseProtocol {
    
    private let repository: ProfileRepositoryProtocol
    private let uploader: AvatarUploaderProtocol
    private let cache: AvatarCacheProtocol
    
    init(repository: ProfileRepositoryProtocol, uploader: AvatarUploaderProtocol, cache: AvatarCacheProtocol) {
        self.repository = repository
        self.uploader = uploader
        self.cache = cache
    }
    
    func execute(_ profile: Profile, newAvatarData: Data?) async throws -> Profile {
        guard let data = newAvatarData else {
            return try await repository.updateProfile(profile)
        }
        let oldURL = profile.avatarUrl
        let newURLString = try await uploader.upload(
            imageData: data,
            userId: profile.id
        )
    
        do {
            let updated = profile.with(avatarUrl: newURLString)
            let saved = try await repository.updateProfile(updated)
            await cache.set(data, for: newURLString)
            
            if let oldURL {
                try? await uploader.delete(byURL: oldURL)
            }
            return saved
        }catch {
            try? await uploader.delete(byURL: newURLString)
            throw error
        }
    }
}
