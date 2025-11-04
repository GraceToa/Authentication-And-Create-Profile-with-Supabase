//
//  ProfileError+Localized.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 29/7/25.
//

import SwiftUI

extension ProfileError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return "Profile not found."
        case .decodingFailed:
            return "Failed to decode profile."
        case .updateFailed:
            return "Failed to update profile."
        case .unknown(let message):
            return message
        }
    }
}
