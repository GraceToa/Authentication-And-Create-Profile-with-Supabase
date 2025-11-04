//
//  UpdateProfileUseCaseProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 22/7/25.
//

import SwiftUI

protocol UpdateProfileUseCaseProtocol {
    func execute(_ profile: Profile, newAvatarData: Data?) async throws -> Profile
}
