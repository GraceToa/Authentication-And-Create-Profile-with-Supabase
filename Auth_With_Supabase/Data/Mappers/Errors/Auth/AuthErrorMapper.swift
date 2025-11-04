//
//  ErrorMapper.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

import Foundation
import PostgREST
import Supabase

/// Maps raw Supabase, PostgREST, or network errors into domain-specific `AuthError` values.
/// Centralizes error handling for authentication flows.
/// Improves readability and consistency across ViewModels and UseCases.

struct AuthErrorMapper {    
    static func map(_ error: Error) -> AuthError {
        if let authError = error as? Auth.AuthError {
            switch authError.errorCode.rawValue {
            case "email_address_invalid":
                return .invalidEmail
            case "user_already_registered":
                return .emailAlreadyInUse
            case "weak_password":
                return .weakPassword
            default:
                return .unknown
            }
        }
        
        if let postgrestError = error as? PostgrestError {
            switch postgrestError.message {
            case let msg where msg.contains("Invalid login credentials"):
                return .invalidCredentials
            case let msg where msg.contains("User already registered"):
                return .emailAlreadyInUse
            default:
                return .unknown
            }
        }
        
        if (error as? URLError) != nil {
            return .network
        }
        return .unknown
    }
}
