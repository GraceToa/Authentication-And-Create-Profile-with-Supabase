//
//  SignUpUseCase.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

/// Handles user registration using the authentication repository.
/// Implements `SignUpUseCaseProtocol` for clear business logic separation.
/// Supports dependency injection and mocking in unit tests.

class SignUpUseCase: SignUpUseCaseProtocol {
    
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) async throws -> User {
        return try await repository.signUp(email: email, password: password)
    }
}
