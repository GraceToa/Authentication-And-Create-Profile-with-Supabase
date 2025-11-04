//
//  SignUpViewModel.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 29/7/25.
//

import SwiftUI

/// ViewModel managing the sign-up, profile creation, and edit logic.
/// Uses dependency injection via `SignUpCoordinatorProtocol` for orchestration.
/// Handles form validation, avatar upload, and success/error states.
/// Supports multiple modes through `SignUpMode` to reuse one flow for register/create/edit.
/// Publishes UI updates reactively for SwiftUI binding and alerts.

@MainActor
final class SignUpViewModel: ObservableObject {
    // MARK: - Published State
    @Published var email: String = ""
    @Published var password = ""
    @Published var fullName: String = ""
    @Published var avatar: Data?
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var mode: SignUpMode
    @Published var showSuccessAlert:Bool = false
    
    // MARK: - Coordinator
    private let coordinatorSignUp: SignUpCoordinatorProtocol
    
    // MARK: - Init
    init(coordinatorSignUp: SignUpCoordinatorProtocol, mode: SignUpMode) {
        self.coordinatorSignUp = coordinatorSignUp
        self.mode = mode
        if case let .edit(profile) = mode {
            self.email = profile.email
            self.fullName = profile.fullName
            self.mode = .editProfile
        }
    }
    
    // MARK: - Actions
    func submit(overrideMode: SignUpMode? = nil) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        guard email.isValidEmail else {
            errorMessage = "Invalid email format."
            return
        }
        do {
            if case .register = overrideMode {
                _ = try await coordinatorSignUp.signUpRegister(email: email, password: password)
                showSuccessAlert = true
            }else if case .registerAndCreateProfile = overrideMode {
                try await coordinatorSignUp.signUpRegisterAndCreateProfile(email: email, password: password, username: fullName, avatarData: avatar)
                showSuccessAlert = true
            }
        }catch let error as AuthError {
            errorMessage = error.localizedDescription
        }catch let error as ProfileError {
            errorMessage = error.localizedDescription
        }catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - UI Helpers
    func dismissAlert() {
        showSuccessAlert = false
    }
}


