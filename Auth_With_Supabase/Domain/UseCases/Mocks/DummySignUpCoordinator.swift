//
//  MockSignUpCoordinator.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 1/8/25.
//

import Foundation

/// Dummy implementation of `SignUpCoordinatorProtocol` used in previews and unit tests.
/// Provides no-op methods to simulate sign-up flows without real dependencies.

final class DummySignUpCoordinator: SignUpCoordinatorProtocol {
    func signUpRegister(
        email: String,
        password: String
    ) async throws {
        // no-op
    }
    
    func signUpRegisterAndCreateProfile(
        email: String,
        password: String,
        username: String,
        avatarData: Data?
    ) async throws {
        // no-op
    }
}
