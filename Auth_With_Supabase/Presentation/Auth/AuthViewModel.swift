//
//  AuthViewModel.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 17/7/25.
//

import SwiftUI

/// ViewModel managing authentication logic and state for the app.
/// Uses dependency-injected UseCases to handle sign-in, sign-out, and session restoration.
/// Publishes UI-reactive state (`user`, `errorMessage`, `isLoading`) for SwiftUI binding.
/// Ensures UI updates run on the main thread via `@MainActor`.
/// Includes `restoreSessionIfNeeded()` for seamless session recovery on app launch.
/// Keeps business logic decoupled from UI, enabling easy testing and mock injection.

@MainActor
final class AuthViewModel: ObservableObject {
    // MARK: - Input
    @Published var email: String = ""
    @Published var password: String = ""
    
    // MARK: - Output
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    // MARK: - Dependencies
    private let signInUseCase: SignInUseCaseProtocol
    private let getCurrentUserUseCase: UserCurrentUseCaseProtocol
    private let signOutUseCase: SignOutUseCaseProtocol
    
    // MARK: - Init
    init(
        signInUseCase: SignInUseCaseProtocol,
        getCurrentUserUseCase: UserCurrentUseCaseProtocol,
        signOutUseCase: SignOutUseCaseProtocol,
    ) {
        self.signInUseCase = signInUseCase
        self.getCurrentUserUseCase = getCurrentUserUseCase
        self.signOutUseCase = signOutUseCase
    }
    
    // MARK: - Actions
    @MainActor
    func signIn() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let authenticatedUser = try await signInUseCase.execute(email: email, password: password)
            user = authenticatedUser
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = AuthError.unknown.localizedDescription
        }
    }
    
    func signOut() async {
        do {
            try await signOutUseCase.execute()
            self.user = nil
        }catch let error as AuthError {
            errorMessage = error.localizedDescription
        }catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func restoreSession() async {
        isLoading = true
        do {
            user = try await getCurrentUserUseCase.execute()
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = AuthError.unknown.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - Session Restoration
extension AuthViewModel {
    func restoreSessionIfNeeded() async {
        guard user == nil else { return }
        await restoreSession()
    }
}
