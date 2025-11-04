//
//  ProfileErrorMapper.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 29/7/25.
//

import SwiftUI
import PostgREST

/// Translates network and PostgREST errors into domain-specific `ProfileError` types.
/// Ensures consistent error handling for profile operations.
/// Simplifies ViewModel logic and improves testability.

struct ProfileErrorMapper {
    static func map(_ error: Error) -> ProfileError {
        if let urlError = error as? URLError {
            return .unknown("Network error: \(urlError.localizedDescription)")
        }
        
        if let postgrestError = error as? PostgrestError {
            switch postgrestError.message.lowercased() {
            case let msg where msg.contains("violates foreign key"):
                return .updateFailed
            case let msg where msg.contains("not found"):
                return .notFound
            default:
                return .unknown(postgrestError.message)
            }
        }
        return .unknown(error.localizedDescription)
    }
}
