//
//  ProfileView.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 22/7/25.
//

import SwiftUI

/// Displays the user’s profile details, including avatar, name, and email.
/// Supports editing via a sheet and deletion with confirmation alert.
/// Integrates with `ProfileViewModel`, `AuthViewModel`, and `NavigationCoordinator`.
/// Provides real-time updates through reactive `@ObservedObject` bindings.
/// Centralized UI for viewing, editing, and deleting user profiles.

struct ProfileDetailView: View {
    
    @ObservedObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Avatar
            if let data = profileViewModel.avatarData,
               let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 4)
            } else {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .foregroundColor(.gray)
            }
            
            // MARK: - Profile Info
            if let profile = profileViewModel.profile {
                Form {
                    Section {
                        Text("Name: \(profile.fullName)")
                        Text("Email: \(profile.email)")
                        Text("Created at: \(profile.createdAt, style: .date)")
                    }
                }
                
                Button {
                    navigationCoordinator.showEditProfileSheet(profile)
                } label: {
                    Label("Edit Profile", systemImage: "square.and.pencil")
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "trash.fill")
                }
            }
        }
        .alert("¿Delete profile?", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) { }
            Button("OK", role: .destructive) {
                Task {
                    if let user = authViewModel.user {
                        await profileViewModel.deleteProfile(userId: user.id)
                        await MainActor.run {
                            profileViewModel.profile = nil
                            navigationCoordinator.pop()
                        }
                    }
                }
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}
