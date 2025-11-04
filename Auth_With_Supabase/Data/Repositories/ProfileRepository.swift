//
//  ProfileRepository.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

import Foundation
import Supabase

/// Handles all CRUD operations for user profiles using Supabase.
/// Implements `ProfileRepositoryProtocol` to abstract data access logic.
/// Maps Supabase and network errors via `ProfileErrorMapper`.
/// Ensures clean separation between data and domain layers.

class ProfileRepository: ProfileRepositoryProtocol {
    
    private let client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    func createProfile(
        userId: UUID,
        email: String,
        fullName: String,
        avatar_url: String? = nil
    ) async throws {
        do {
            let _: PostgrestResponse<Void> = try await client
                .from("profiles")
                .insert([
                    "id": userId.uuidString,
                    "email": email,
                    "full_name": fullName,
                    "avatar_url": avatar_url ?? ""
                ])
                .execute()
        }catch {
            throw ProfileErrorMapper.map(error)
        }
    }
    
    func fetchProfile(userId: UUID) async throws -> Profile {
        do {
            let response: PostgrestResponse<Profile> = try await client
                .from("profiles")
                .select("id, email, full_name, avatar_url, created_at")
                .eq("id", value: userId.uuidString)
                .single()
                .execute()
            try SupabaseResponseValidator.checkStatus(response)
            return response.value
        } catch {
            throw ProfileErrorMapper.map(error)
        }
    }
    
    func updateProfile(_ profile: Profile) async throws -> Profile {
        do {
            let response: PostgrestResponse<Profile> = try await client
                .from("profiles")
                .update(profile)
                .eq("id", value: profile.id)
                .select()
                .single()
                .execute()
            try SupabaseResponseValidator.checkStatus(response)
            return response.value
        }catch {
            throw ProfileErrorMapper.map(error)
        }
    }
    
    func deleteProfile(userId: UUID) async throws {
        do {
            try await client
                .from("profiles")
                .delete()
                .eq("id", value: userId.uuidString)
                .execute()
        } catch {
            throw ProfileErrorMapper.map(error)
        }
    }
    
    func fetchProfileAvatarUrl(userId: UUID) async throws -> String? {
        do {
            let response: PostgrestResponse<AvatarUrlDTO> = try await client
                .from("profiles")
                .select("avatar_url")
                .eq("id", value: userId.uuidString)
                .single()
                .execute()
            try SupabaseResponseValidator.checkStatus(response)
            return response.value.avatar_url
        } catch {
            throw ProfileErrorMapper.map(error)
        }
    }
}

private struct AvatarUrlDTO: Decodable {
    let avatar_url: String?
}

