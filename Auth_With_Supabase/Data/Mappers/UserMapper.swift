//
//  UserMapper.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

import Supabase
import Foundation

/// Converts a `Supabase.User` object into the app’s domain `User` model.
/// Ensures decoupling between Supabase SDK models and internal entities.

struct UserMapper {
    static func map(_ supabaseUser: Supabase.User) -> User {
        return User(
            id: supabaseUser.id,
            email: supabaseUser.email ?? ""
        )
    }
}
