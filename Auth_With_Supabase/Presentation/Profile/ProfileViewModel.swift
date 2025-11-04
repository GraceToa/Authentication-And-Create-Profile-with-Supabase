//
//  ProfileViewModel.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 22/7/25.
//

import Foundation

/// ViewModel managing all profile-related logic and state.
/// Handles creation, update, deletion, and loading of profiles and avatars.
/// Coordinates multiple UseCases and publishes UI state reactively.
/// Uses optional `ImageLoader` for asynchronous avatar fetching and caching.
/// Designed for testability, separation of concerns, and SwiftUI reactivity.

@MainActor
class ProfileViewModel: ObservableObject {
    
    // MARK: - Published State
    @Published var profile: Profile?
    @Published var avatarData: Data?
    @Published var showSuccessAlert:Bool = false
    @Published var errorMessage: String?
    @Published var infoMessage: String?
    
    // MARK: - Dependencies
    private let createProfileUseCase: CreateProfileUseCaseProtocol
    private let fetchProfileUseCase: FetchProfileUseCaseProtocol
    private let updateProfileUseCase: UpdateProfileUseCaseProtocol
    private let deleteProfileUseCase: DeleteProfileUseCaseProtocol
    private let imageLoader: ImageLoaderProtocol? // opcional si no lo inyectas
    
    // MARK: - Init
    init(
        fetchProfileUseCase: FetchProfileUseCaseProtocol,
        updateProfileUseCase: UpdateProfileUseCaseProtocol,
        createProfileUseCase: CreateProfileUseCaseProtocol,
        deleteProfileUseCase: DeleteProfileUseCaseProtocol,
        imageLoader: ImageLoaderProtocol? = nil
    ) {
        self.fetchProfileUseCase = fetchProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.createProfileUseCase = createProfileUseCase
        self.deleteProfileUseCase = deleteProfileUseCase
        self.imageLoader = imageLoader
    }
    
    // MARK: - CRUD
    func createProfileWith(
        userId: UUID,
        email: String,
        username: String,
        avatarData: Data? = nil
    ) async {
        do {
            try await createProfileUseCase
                .execute(
                    userId: userId,
                    email: email,
                    username: username,
                    avatarData: avatarData
                )
            let profile = try await fetchProfileUseCase.execute(
                userId: userId
            )
            self.profile = profile
            self.showSuccessAlert = true
            await loadAvatar()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateProfile(
        _ current: Profile,
        fullName: String,
        newAvatarData: Data? = nil
    ) async {
        do {
            let edited = current.with(
                fullName: fullName
            )
            let saved = try await updateProfileUseCase.execute(
                edited,
                newAvatarData: newAvatarData
            )
            self.profile = saved
            if newAvatarData != nil || current.avatarUrl != saved.avatarUrl {
                await loadAvatar()
            }
            showSuccessAlert = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteProfile(userId: UUID) async  {
        do {
            try await deleteProfileUseCase.execute(userId: userId)
            infoMessage = "Profile successfully deleted"
            self.profile = nil
            self.avatarData = nil
        }catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Loading
    func loadProfileWith(userId:UUID) async throws {
        let p = try await fetchProfileUseCase.execute(userId: userId)
        self.profile = p
        await loadAvatar()
    }
    
    func loadIfNeeded(userId: UUID) async {
        guard profile == nil else { return }
        try? await loadProfileWith(userId: userId)
    }
    
    // MARK: - Avatar
    func loadAvatar() async {
        guard
            let urlStr = profile?.avatarUrl,
            let url = URL(string: urlStr),
            let loader = imageLoader
        else {
            self.avatarData = nil
            return
        }
        do {
            self.avatarData = try await loader.load(url)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - UI Helpers
    func dismissAlert() {
        showSuccessAlert = false
    }
}

// MARK: - Validation
extension ProfileViewModel {
    func canSaveEdit(newFullName: String, newAvatarData: Data?) -> Bool {
        let trimmedNew = newFullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedOld = profile?.fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameChanged   = !trimmedNew.isEmpty && trimmedNew != trimmedOld
        let avatarChanged = (newAvatarData != nil)
        return nameChanged || avatarChanged
    }
}
