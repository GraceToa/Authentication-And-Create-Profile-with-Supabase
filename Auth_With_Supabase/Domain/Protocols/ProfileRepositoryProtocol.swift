//
//  ProfileRepositoryProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

import Foundation

protocol ProfileRepositoryProtocol {
    func createProfile(userId: UUID, email: String, fullName: String, avatar_url: String?) async throws
    func fetchProfile(userId: UUID) async throws -> Profile
    func updateProfile(_ profile: Profile) async throws -> Profile
    func deleteProfile(userId: UUID) async throws
    func fetchProfileAvatarUrl(userId: UUID) async throws -> String?
}
