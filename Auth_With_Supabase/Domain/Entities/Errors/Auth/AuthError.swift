//
//  AuthError.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

public enum AuthError: Error, Equatable {
    case noUser
    case invalidCredentials
    case invalidEmail
    case emailAlreadyInUse
    case unauthenticated
    case network
    case unknown
    case weakPassword
}
