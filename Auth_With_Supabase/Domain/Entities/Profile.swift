//
//  Profile.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

import Foundation

/// Represents a user profile stored in Supabase.
/// Encapsulates user identity, email, name, avatar URL, and creation date.
/// Provides helper methods to create updated copies (`with(...)`) and a mock instance for testing.

struct Profile: Codable, Equatable {
    let id: UUID
    let email: String
    let fullName: String
    let avatarUrl: String?
    let createdAt: Date
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName = "full_name"
        case avatarUrl = "avatar_url"
        case createdAt = "created_at"
    }
}

// MARK: - Mutating Helpers
extension Profile {
    func with(avatarUrl: String?) -> Profile {
        Profile(
            id: id,
            email: email,
            fullName: fullName,
            avatarUrl: avatarUrl,
            createdAt: createdAt
        )
    }
    
    func with(fullName: String) -> Profile {
        Profile(id: id, email: email, fullName: fullName, avatarUrl: avatarUrl, createdAt: createdAt)
    }
}

// MARK: - Mock
extension Profile {
    static let mock: Profile = .init(
        id: UUID(),
        email: "test@example.com",
        fullName: "Test User",
        avatarUrl: "https://example.com/avatar.png",
        createdAt: .now
    )
}
