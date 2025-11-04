//
//  SignInUseCase.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

/// Handles the sign-in flow using the authentication repository.
/// Implements `SignInUseCaseProtocol` to separate business logic from UI.
/// Delegates actual sign-in to `AuthRepositoryProtocol` for testability.

class SignInUseCase: SignInUseCaseProtocol {
    
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) async throws -> User {
        try await repository.signIn(email: email, password: password)
    }
}
