//
//  HomeView+Preview.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 23/7/25.
//

import SwiftUI

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewHost()
            .previewDisplayName("Home → Go to Profile")
    }
    
    private struct PreviewHost: View {
        var factory:MockViewModelFactory
        @StateObject var navigationCoordinator: NavigationCoordinator
        @StateObject var authViewModel: AuthViewModel
        @StateObject var profileViewModel: ProfileViewModel
        
        init() {
            let f = MockViewModelFactory()
            factory = f
            let authVM = f.makeAuthViewModel()
            _navigationCoordinator = StateObject(wrappedValue: NavigationCoordinator(factory: f))
            _authViewModel = StateObject(wrappedValue: authVM)
            
            let vm = f.makeProfileViewModel()
            vm.profile = .mock
            _profileViewModel = StateObject(wrappedValue: vm)
        }
        
        var body: some View {
            NavigationStack(path: $navigationCoordinator.path) {
                HomeView(
                    profileViewModel: profileViewModel
                )
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
                }
            }
        }
    }
}

