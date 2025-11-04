//
//  MockUseCases.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 24/7/25.
//

import Foundation

/// Mock implementations of authentication Auth UseCases for unit testing and previews.
/// Allow controlled success or failure via `Result<User, Error>`.
/// `DummySignOutUseCase` provides a no-op implementation for sign-out tests.

final class MockSignInUseCase: SignInUseCaseProtocol {
    var result: Result<User, Error>
    
    init(result: Result<User, Error>) {
        self.result = result
    }
    
    func execute(email: String, password: String) async throws -> User {
        switch result {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }
}

final class MockSignUpUseCase: SignUpUseCaseProtocol {
    var result: Result<User, Error>
    
    init(result: Result<User, Error>) {
        self.result = result
    }
    
    func execute(email: String, password: String) async throws -> User {
        switch result {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }
}

final class MockUserCurrentUseCase: UserCurrentUseCaseProtocol {
    var result: Result<User, Error>
    
    init(result: Result<User, Error>) {
        self.result = result
    }
    
    func execute() async throws -> User {
        switch result {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }
}

final class DummySignOutUseCase: SignOutUseCaseProtocol {
    func execute() async throws { }
}



