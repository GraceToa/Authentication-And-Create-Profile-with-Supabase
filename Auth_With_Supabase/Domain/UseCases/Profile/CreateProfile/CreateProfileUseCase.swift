//
//  CreateProfileUseCase.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 29/7/25.
//

import SwiftUI

/// Handles profile creation, including optional avatar upload.
/// Implements `CreateProfileUseCaseProtocol` to separate business logic from UI.
/// Coordinates between `ProfileRepositoryProtocol` and `AvatarUploaderProtocol`.

class CreateProfileUseCase: CreateProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    private let uploader: AvatarUploaderProtocol
    
    init(repository: ProfileRepositoryProtocol, uploader: AvatarUploaderProtocol) {
        self.repository = repository
        self.uploader = uploader
    }
    
    func execute(
        userId: UUID,
        email: String,
        username: String,
        avatarData: Data?
    ) async throws {
        var avatarUrl: String? = nil
        
        if let data = avatarData {
            avatarUrl = try await uploader
                .upload(
                    imageData: data,
                    userId: userId
                )
        }
        try await repository
            .createProfile(
                userId: userId,
                email: email,
                fullName: username,
                avatar_url: avatarUrl
            )
    }
}
