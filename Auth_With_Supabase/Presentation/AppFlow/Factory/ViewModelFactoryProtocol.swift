//
//  ViewModelFactoryProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 24/7/25.
//

protocol ViewModelFactoryProtocol {    
    @MainActor func makeAuthViewModel() -> AuthViewModel
    @MainActor func makeProfileViewModel() -> ProfileViewModel
    @MainActor func makeSignUpViewModel(mode:SignUpMode) -> SignUpViewModel
}
