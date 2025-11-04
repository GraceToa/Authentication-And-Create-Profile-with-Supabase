//
//  AuthError+Localized.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

import SwiftUI

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noUser:
            return "Could not get user."
        case .invalidCredentials:
            return "Email or password incorrect."
        case .unauthenticated:
            return "There is not active session."
        case .unknown:
            return "An unexpected error occurred."
        case .emailAlreadyInUse:
            return "User already registered."
        case .network:
            return "Network error."
        case .invalidEmail:
            return "The email address is invalid."
        case .weakPassword:
            return "Password is too weak."
        }
    }
}
