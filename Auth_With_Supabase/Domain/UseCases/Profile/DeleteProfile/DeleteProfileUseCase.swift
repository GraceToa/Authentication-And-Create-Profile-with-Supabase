//
//  DeleteProfileUseCase.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 17/10/25.
//

import Foundation

/// Deletes a user profile and its associated avatar from storage and cache.
/// Implements `DeleteProfileUseCaseProtocol` ensuring cleanup across layers.
/// Coordinates repository, uploader, and cache for consistent data removal.

struct DeleteProfileUseCase: DeleteProfileUseCaseProtocol {
    
    private let repository: ProfileRepositoryProtocol
    private let uploader: AvatarUploaderProtocol
    private let cache: AvatarCacheProtocol
    
    init(
        repository: ProfileRepositoryProtocol,
        uploader: AvatarUploaderProtocol,
        cache: AvatarCacheProtocol
    ) {
        self.repository = repository
        self.uploader = uploader
        self.cache = cache
    }
    
    func execute(userId: UUID) async throws {
        try await repository.deleteProfile(userId: userId)
        if let url = try? await repository.fetchProfileAvatarUrl(userId: userId),
           !url.isEmpty {
            try await uploader.delete(byURL: url)
        }
        await cache.remove(for: userId.uuidString)
    }
}
