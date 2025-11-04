//
//  ProfileView+Preview.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 23/7/25.
//

import SwiftUI

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewHost()
    }
    
    private struct PreviewHost:View {
        private let factory:MockViewModelFactory
        @StateObject var navigationCoordinator: NavigationCoordinator
        @StateObject var authViewModel: AuthViewModel
        @StateObject var profileViewModel: ProfileViewModel
        
        init() {
            let f = MockViewModelFactory()
            factory = f
            _navigationCoordinator = StateObject(wrappedValue: NavigationCoordinator(factory: f))
            _authViewModel = StateObject(wrappedValue: f.makeAuthViewModel())
            
            let vm = f.makeProfileViewModel()
            vm.profile = .mock
            _profileViewModel = StateObject(wrappedValue: vm)
        }
        
        var body: some View {
            NavigationStack(path: $navigationCoordinator.path) {
                ProfileDetailView(profileViewModel: profileViewModel)
                
            }
            .environmentObject(navigationCoordinator)
            .environmentObject(authViewModel)
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



