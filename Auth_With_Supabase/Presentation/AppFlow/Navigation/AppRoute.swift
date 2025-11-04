//
//  AppRoute.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 23/7/25.
//

import SwiftUI

enum AppRoute: Hashable {
    case showProfile
    case showSignUpCreateProfile
}

enum AppSheet: Identifiable {
    case editProfile(Profile, token: UUID = UUID())
    var id: String {
        switch self {
        case .editProfile(_, let token): token.uuidString
        }
    }
}

