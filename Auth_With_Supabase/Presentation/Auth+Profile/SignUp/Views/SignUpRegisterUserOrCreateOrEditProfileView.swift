//
//  SignUpView.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 17/7/25.
//

import SwiftUI

/// Reusable SwiftUI view for all sign-up and profile operations.
/// Dynamically adapts to the current `SignUpMode` (register, create, or edit profile).
/// Handles user input, avatar selection, and reactive validation states.
/// Integrates with `AuthViewModel`, `SignUpViewModel`, and `ProfileViewModel` via DI.
/// Centralizes logic for registering users, creating new profiles, and editing existing ones.
/// Displays contextual alerts and success feedback, ensuring consistent UX across flows.

struct SignUpRegisterUserOrCreateOrEditProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @ObservedObject var signUpViewModel: SignUpViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Text(signUpViewModel.modeTitle)
                .font(.title)
            Button { isImagePickerPresented = true } label: {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                        } else if let data = profileViewModel.avatarData,
                                  let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .shadow(radius: 3)
                    
                    Image(systemName: iconForMode)
                        .font(.system(size: 14))
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                        .offset(x: -6, y: -6)
                }
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage)
            }
            TextField("Name", text: $signUpViewModel.fullName)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            if [.register, .registerAndCreateProfile, .editProfile].contains(signUpViewModel.mode) {
                TextField("Email", text: $signUpViewModel.email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .disabled(!signUpViewModel.isEmailEditable)
                    .padding(.vertical, 12)
                    .padding(.leading, 12)
                    .padding(.trailing, 36) // espacio para el icono
                    .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                    .overlay(alignment: .trailing) {
                        if !signUpViewModel.isEmailEditable {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.secondary)
                                .padding(.trailing, 10)
                                .allowsHitTesting(false) // no bloquea el foco
                                .transition(.opacity)
                        }
                    }
            }
            if [.register, .registerAndCreateProfile].contains(signUpViewModel.mode) {
                SecureField("Password", text: $signUpViewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            actionButton
            if let error = signUpViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        .hideKeyboardOnTap()
        .alert(alertTitle, isPresented: isAnyAlertPresented) {
            Button("OK") {
                if profileViewModel.showSuccessAlert {
                    profileViewModel.dismissAlert()
                    navigationCoordinator.popToRoot()
                } else if signUpViewModel.showSuccessAlert {
                    signUpViewModel.dismissAlert()
                    dismiss()
                }
            }
        }
    }
    
    private var iconForMode: String {
        switch signUpViewModel.mode {
        case .editProfile: return "pencil.circle.fill"
        default: return "camera.fill"
        }
    }
    
    private var alertTitle: String {
        if profileViewModel.showSuccessAlert {
            return "Profile created successfully"
        } else if signUpViewModel.showSuccessAlert {
            return "Register completed"
        } else {
            return ""
        }
    }
    
    private var isAnyAlertPresented: Binding<Bool> {
        Binding(
            get: { profileViewModel.showSuccessAlert || signUpViewModel.showSuccessAlert },
            set: { newValue in
                if !newValue {
                    profileViewModel.showSuccessAlert = false
                    signUpViewModel.showSuccessAlert = false
                }
            }
        )
    }
    
    @ViewBuilder
    private var actionButton: some View {
        switch signUpViewModel.mode {
        case .createProfile:
            Button("Create Profile") {
                Task {
                    if let user = authViewModel.user {
                        let avatarData = selectedImage?.jpegData(compressionQuality: 0.8)
                        
                        await profileViewModel.createProfileWith(
                            userId: user.id,
                            email: user.email,
                            username: signUpViewModel.fullName,
                            avatarData: avatarData
                        )
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(signUpViewModel.fullName.isEmpty)
        case .editProfile:
            Button("Save Profile") {
                Task {
                    if let profile = profileViewModel.profile {
                        let avatarData = selectedImage?.jpegData(compressionQuality: 0.8)
                        await profileViewModel.updateProfile(
                            profile,
                            fullName: signUpViewModel.fullName,
                            newAvatarData: avatarData
                        )
                        await MainActor.run {
                            navigationCoordinator.dismissSheet()
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                !profileViewModel.canSaveEdit(
                    newFullName: signUpViewModel.fullName,
                    newAvatarData: selectedImage?.jpegData(
                        compressionQuality: 0.8
                    )
                )
            )
        default:
            VStack {
                Button("Save Register") {
                    Task {
                        await signUpViewModel.submit(overrideMode: .register)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    signUpViewModel.email.isEmpty || signUpViewModel.password.isEmpty
                )
                
                Button("Save Register and Profile") {
                    signUpViewModel.avatar = selectedImage?.jpegData(compressionQuality: 0.8)
                    Task {
                        await signUpViewModel.submit(overrideMode: .registerAndCreateProfile)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    signUpViewModel.email.isEmpty || signUpViewModel.password.isEmpty || signUpViewModel.fullName.isEmpty
                )
            }
        }
    }
}

