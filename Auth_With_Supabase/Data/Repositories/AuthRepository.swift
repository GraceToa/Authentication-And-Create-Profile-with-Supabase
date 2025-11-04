//
//  SupabaseProfileRepository.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

import Supabase

final class AuthRepository: AuthRepositoryProtocol {
    private let provider: SupabaseClientProvider
    
    init(provider: SupabaseClientProvider) {
        self.provider = provider
    }
    
    func signUp(email: String, password: String) async throws -> User {
        do {
            let session = try await provider.client.auth.signUp(
                email: email,
                password: password
            )
            return UserMapper.map(session.user)
        } catch {
            throw AuthErrorMapper.map(error)
        }
    }
    
    func signIn(email: String, password: String) async throws -> User {
        do {
            let session = try await provider.client.auth.signIn(
                email: email,
                password: password
            )
            return UserMapper.map(session.user)
        } catch {
            throw AuthErrorMapper.map(error)
        }
    }
    
    func getCurrentUser() async throws -> User {
        guard let user = provider.client.auth.currentUser else {
            throw AuthError.unauthenticated
        }
        return UserMapper.map(user)
    }
    
    func signOut() async throws {
        do {
            try await provider.client.auth.signOut()
            provider.reset()
        } catch {
            throw AuthErrorMapper.map(error)
        }
    }
}
