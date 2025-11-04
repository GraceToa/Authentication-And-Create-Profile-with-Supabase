//
//  MockAuthRepository.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 23/7/25.
//

import SwiftUI

/// Mock implementation of `AuthRepositoryProtocol` for unit testing and previews.
/// Returns static `User.mock` instances and simulates successful auth operations.
/// Used to isolate ViewModels and UseCases from real Supabase dependencies.

struct MockAuthRepository: AuthRepositoryProtocol {
    func signUp(email: String, password: String) async throws -> User {
        User.mock
    }
    
    func signIn(email: String, password: String) async throws -> User {
        User.mock
    }
    
    func getCurrentUser() async throws -> User {
        User.mock
    }
    
    func signOut() async throws {}
}

