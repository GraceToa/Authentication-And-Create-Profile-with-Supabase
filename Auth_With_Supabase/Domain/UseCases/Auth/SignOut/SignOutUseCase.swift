//
//  SignOutUseCase.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

/// Handles user sign-out logic through the authentication repository.
/// Implements `SignOutUseCaseProtocol` for clean separation of concerns.
/// Enables dependency injection and easy mocking for testing.

class SignOutUseCase: SignOutUseCaseProtocol {
    
    private let repository: AuthRepositoryProtocol
        
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws {
        try await repository.signOut()
    }
}
