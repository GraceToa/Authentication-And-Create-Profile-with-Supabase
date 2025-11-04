//
//  ProfileError.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

import Foundation

enum ProfileError: Error {
    case notFound
    case decodingFailed
    case updateFailed
    case unknown(String)
}

