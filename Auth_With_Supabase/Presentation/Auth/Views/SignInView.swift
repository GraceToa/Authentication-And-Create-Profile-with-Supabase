//
//  SignInView.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 17/7/25.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var signUpViewModel: SignUpViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUp = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image("Grace")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .clipShape(Circle())
                .padding(.top, 40)
            
            VStack(spacing: 16) {
                InputField(systemIcon: "envelope.fill", placeholder: "Email", text: $email, isSecure: false)
                InputField(systemIcon: "key.fill", placeholder: "Password", text: $password, isSecure: true)
            }
            .padding(.horizontal, 32)
            
            Button("Sign In") {
                signIn()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 30)
            
            Button("Sign Up") {
                showSignUp = true
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.horizontal)
        .sheet(isPresented: $showSignUp) {
            SignUpRegisterUserOrCreateOrEditProfileView(
                signUpViewModel: signUpViewModel,
                profileViewModel: profileViewModel
            )
        }
        .hideKeyboardOnTap()
    }
    
    private func signIn() {
        Task {
            authViewModel.email = email.lowercased()
            authViewModel.password = password
            await authViewModel.signIn()
        }
    }
}

private struct InputField: View {
    let systemIcon: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    
    var body: some View {
        HStack {
            Image(systemName: systemIcon)
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(.emailAddress)
            }
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
    }
}
