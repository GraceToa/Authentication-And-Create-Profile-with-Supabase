//
//  CreateProfileUseCaseProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 29/7/25.
//

import SwiftUI

protocol CreateProfileUseCaseProtocol {
    func execute(userId: UUID, email: String, username: String, avatarData: Data?) async throws
}
