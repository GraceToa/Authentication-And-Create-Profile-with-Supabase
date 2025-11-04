//
//  FetchProfileProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 22/7/25.
//

import Foundation

protocol FetchProfileUseCaseProtocol {
    func execute(userId: UUID) async throws -> Profile
}
