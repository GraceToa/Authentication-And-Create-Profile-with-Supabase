//
//  SignUpCoordinatorProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 29/7/25.
//

import Foundation

protocol SignUpCoordinatorProtocol {
    func signUpRegisterAndCreateProfile(
        email: String,
        password: String,
        username: String,
        avatarData: Data?
    ) async throws
    
    func signUpRegister(email: String, password: String) async throws
}
