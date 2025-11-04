//
//  AuthViewModelTest.swift
//  Auth_With_SupabaseTests
//
//  Created by Grace Toa on 1/8/25.
//

import XCTest
@testable import Auth_With_Supabase

@MainActor
final class AuthViewModelTest: XCTestCase {
    
    func test_signIn_success_setsUser() async {
        let expectedUser = User.mock
        let factory =  MockViewModelFactory(
            authResult: .success(expectedUser),
            profileResult: .success(Profile.mock)
        )
        let viewModel =  factory.makeAuthViewModel()
        
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        
        await viewModel.signIn()
        
        XCTAssertEqual(viewModel.user?.email, expectedUser.email)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_signIn_failure_setsErrorMessage() async {
        let factory = MockViewModelFactory(
            authResult: .failure(AuthError.invalidCredentials),
            profileResult: .success(Profile.mock)
        )
        let viewModel = factory.makeAuthViewModel()
        
        viewModel.email = "wrong@example.com"
        viewModel.password = "wrongpass"
        
        await viewModel.signIn()
        
        XCTAssertNil(viewModel.user)
        XCTAssertEqual(viewModel.errorMessage, AuthError.invalidCredentials.localizedDescription)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_restoreSession_success_setsUser() async {
        let expectedUser = User.mock
        
        final class MockRestoreUseCase: UserCurrentUseCaseProtocol {
            func execute() async throws -> User {
                User.mock
            }
        }
        
        let viewModel = AuthViewModel(
            signInUseCase: MockSignInUseCase(result: .success(expectedUser)), // solo para inicializar
            getCurrentUserUseCase: MockRestoreUseCase(),
            signOutUseCase: DummySignOutUseCase()
        )
        
        await viewModel.restoreSession()
        
        XCTAssertEqual(viewModel.user?.email, expectedUser.email)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    
    @MainActor
    func test_restoreSession_failure_setsErrorMessage() async {
        let expectedUser = User.mock
        
        final class FailingRestoreUseCase: UserCurrentUseCaseProtocol {
            func execute() async throws -> User {
                throw AuthError.unauthenticated
            }
        }
        
        let viewModel = AuthViewModel(
            signInUseCase: MockSignInUseCase(result: .success(expectedUser)),
            getCurrentUserUseCase: FailingRestoreUseCase(),
            signOutUseCase: DummySignOutUseCase()
        )
        
        // Act
        await viewModel.restoreSession()
        
        // Assert
        XCTAssertNil(viewModel.user)
        XCTAssertEqual(viewModel.errorMessage, AuthError.unauthenticated.localizedDescription)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    
}
