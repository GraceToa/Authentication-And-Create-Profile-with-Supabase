//
//  AuthRepositoryProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

protocol AuthRepositoryProtocol {
    func signUp(email: String, password: String) async throws -> User
    func signIn(email: String, password: String) async throws -> User
    func getCurrentUser() async throws -> User
    func signOut() async throws
}
