//
//  SignUpCoordinator.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 29/7/25.
//

import Foundation

/// Coordinates user sign-up and optional profile creation flows.
/// Combines `SignUpUseCase` and `CreateProfileUseCase` into cohesive operations.
/// Implements `SignUpCoordinatorProtocol` for clear orchestration and testability.
/// Ensures sequential registration and profile persistence.

final class SignUpCoordinator: SignUpCoordinatorProtocol {
    
    private let signUpUseCase: SignUpUseCaseProtocol
    private let createProfileUseCase: CreateProfileUseCaseProtocol

    init(
        signUpUseCase: SignUpUseCaseProtocol,
        createProfileUseCase: CreateProfileUseCaseProtocol
    ) {
        self.signUpUseCase = signUpUseCase
        self.createProfileUseCase = createProfileUseCase
    }
    
    func signUpRegisterAndCreateProfile(
        email: String,
        password: String,
        username: String,
        avatarData: Data?
    ) async throws {
        let user = try await signUpUseCase.execute(
            email: email,
            password: password
        )
        try await createProfileUseCase
            .execute(
            userId: user.id,
            email: email,
            username: username,
            avatarData: avatarData
        )
    }
    
    func signUpRegister(email: String, password: String) async throws {
        _ = try await signUpUseCase.execute(email: email, password: password)
    }
}
