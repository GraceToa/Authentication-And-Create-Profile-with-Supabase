//
//  Profile.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 18/7/25.
//

import Foundation

/// Represents an authenticated user in the domain layer.
/// Contains minimal identity information: `id` and `email`.
/// Provides a static `mock` instance for previews and testing.

struct User: Equatable {
    let id: UUID
    let email: String
}

// MARK: - Mock
extension User {
    static let mock = User(
        id: UUID(),
        email: "test@example.com"
    )
}
