//
//  SupabaseResponseValidator.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

import Supabase

/// Validates Supabase `PostgrestResponse` status codes and maps them to domain errors.
/// Throws `ProfileError` for non-successful HTTP responses (e.g., 404 → `.notFound`).
/// Ensures consistent backend error handling across repositories and use cases.

enum SupabaseResponseValidator {
    static func checkStatus<T>(_ response: PostgrestResponse<T>) throws {
        let statusCode = response.response.statusCode
        
        switch statusCode {
        case 200...299:
            return
        case 404:
            throw ProfileError.notFound
        default:
            throw ProfileError.unknown("Status code \(statusCode)")
        }
    }
}
