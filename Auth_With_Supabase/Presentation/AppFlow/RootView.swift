//
//  RootView.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 17/7/25.
//

import SwiftUI

/// Root entry point that orchestrates the app’s high-level flow based on auth state.
/// Owns shared `NavigationCoordinator`, `AuthViewModel`, and `ProfileViewModel` via DI (no singletons).
/// Binds a `NavigationStack` to `navigationCoordinator.path` for push/pop and handles sheets centrally.
/// On launch, restores the session (`.task`) and routes to Home or Sign-In accordingly.
/// Encapsulates MVVM wiring: builds SignUp ViewModels from the factory for each route/sheet.
/// Testable and preview-friendly: dependencies are provided by a `ViewModelFactoryProtocol` (mockable).
/// Keeps UI lean by delegating business logic to UseCases and repositories.

struct RootView: View {
    
    @StateObject private var navigationCoordinator: NavigationCoordinator
    @StateObject private var authViewModel: AuthViewModel
    @StateObject private var profileViewModel: ProfileViewModel
    
    init(factory: ViewModelFactoryProtocol) {
        let authVM = factory.makeAuthViewModel()
        let profileVM = factory.makeProfileViewModel()
        let navCoordinator  = NavigationCoordinator(factory: factory)
        
        _authViewModel = StateObject(wrappedValue: authVM)
        _profileViewModel = StateObject(wrappedValue: profileVM)
        _navigationCoordinator = StateObject( wrappedValue: navCoordinator)
    }
    
    var body: some View {
        NavigationStack(path: $navigationCoordinator.path) {
            content
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .showProfile:
                        ProfileDetailView(
                            profileViewModel: profileViewModel
                        )
                    case .showSignUpCreateProfile:
                        let vm = navigationCoordinator.factory.makeSignUpViewModel(mode: .createProfile)
                        SignUpRegisterUserOrCreateOrEditProfileView(
                            signUpViewModel: vm,
                            profileViewModel: profileViewModel
                        )
                    }
                }
        }
        .environmentObject(authViewModel)
        .environmentObject(navigationCoordinator)
        .sheet(item: $navigationCoordinator.presentedSheet) { sheet in
            switch sheet {
            case .editProfile(let profile, _):
                let vm = navigationCoordinator.factory.makeSignUpViewModel(mode: .edit(profile))
                SignUpRegisterUserOrCreateOrEditProfileView(
                    signUpViewModel: vm,
                    profileViewModel: profileViewModel
                )
                .environmentObject(navigationCoordinator)
            }
        }
        .task {
            await authViewModel.restoreSessionIfNeeded()
            if authViewModel.user != nil {
                navigationCoordinator.popToRoot()
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if authViewModel.isLoading {
            ProgressView("Loading ...")
        } else if authViewModel.user != nil {
            HomeView(
                profileViewModel: profileViewModel
            )
        } else {
            let signUpVM = navigationCoordinator.factory.makeSignUpViewModel(mode: .registerAndCreateProfile)
            SignInView(
                signUpViewModel: signUpVM,
                profileViewModel: profileViewModel
            )
        }
    }
}
