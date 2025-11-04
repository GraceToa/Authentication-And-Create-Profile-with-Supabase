//
//  SignUpMode.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 7/8/25.
//

enum SignUpMode: Equatable {
    case register
    case registerAndCreateProfile
    case createProfile
    case edit(Profile)
    case editProfile
}
