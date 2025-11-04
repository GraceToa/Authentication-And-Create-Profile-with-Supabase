//
//  UserCurrentUserCase.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

/// Retrieves the currently authenticated user from the repository.
/// Implements `UserCurrentUseCaseProtocol` for consistent access logic.
/// Supports dependency injection and simplifies ViewModel testing.

class UserCurrentUseCase: UserCurrentUseCaseProtocol {
    
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> User {
        try await repository.getCurrentUser()
    }
}
