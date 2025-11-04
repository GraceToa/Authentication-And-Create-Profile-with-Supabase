//
//  HomeView.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 17/7/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Image("Grace")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .clipShape(Circle())
                .shadow(radius: 4)
            
            let userEmail = authViewModel.user?.email ?? "Anonymous"
            Text("Hello, \(userEmail)")
            
            if profileViewModel.profile != nil {
                Button("Go to Profile") {
                    navigationCoordinator.navigate(to: .showProfile)
                }
            } else {
                Button("Create profile") {
                    navigationCoordinator.navigate(to: .showSignUpCreateProfile)
                }
            }
            
            Spacer()
        }
        .padding(.top, 40)
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "togglepower")
                        .accessibilityLabel("Sign Out")
                }
            }
        }
        .alert("¿Do you want to close the session??", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) { }
            Button("OK", role: .destructive) {
                Task {
                    await authViewModel.signOut()
                    await MainActor.run {
                        alertMessage = authViewModel.errorMessage ?? "Session closed successfully ✅"
                    }
                    navigationCoordinator.reset()
                }
            }
        }
        .onAppear {
            if let userId = authViewModel.user?.id {
                Task {
                    await profileViewModel.loadIfNeeded(userId: userId)
                }
            }
        }
    }
}
