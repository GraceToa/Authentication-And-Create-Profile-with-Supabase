//
//  MockProfileRepository.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 30/7/25.
//

import Foundation

/// Mock implementation of `ProfileRepositoryProtocol` for testing and previews.
/// Simulates CRUD operations and allows controlled error injection.
/// Tracks created and updated profiles for verification in unit tests.

final class MockProfileRepository: ProfileRepositoryProtocol {
    
    var createdProfiles: [Profile] = []
    var fetchedProfile: Profile?
    var updatedProfile: Profile?
    
    var shouldThrowError: Bool = false
    
    func createProfile(userId: UUID, email: String, fullName: String, avatar_url: String?) async throws {
        if shouldThrowError {
            throw ProfileError.decodingFailed
        }
        let profile = Profile(
            id: userId,
            email: email,
            fullName: fullName,
            avatarUrl: avatar_url ?? "",
            createdAt: Date()
        )
        createdProfiles.append(profile)
    }
    
    func fetchProfile(userId: UUID) async throws -> Profile {
        if shouldThrowError {
            throw ProfileError.notFound
        }
        guard let profile = fetchedProfile else {
            throw ProfileError.notFound
        }
        return profile
    }
    
    func updateProfile(_ profile: Profile) async throws -> Profile {
        if shouldThrowError {
            throw ProfileError.updateFailed
        }
        updatedProfile = profile
        return profile
    }
    
    func deleteProfile(userId: UUID) async throws {}
    
    func fetchProfileAvatarUrl(userId: UUID) async throws -> String? {
        return ""
    }
}
