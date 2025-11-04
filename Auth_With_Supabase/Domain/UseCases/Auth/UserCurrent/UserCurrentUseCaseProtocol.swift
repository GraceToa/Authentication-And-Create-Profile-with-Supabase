//
//  UserCurrentUserCaseProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 21/7/25.
//

protocol UserCurrentUseCaseProtocol {
    func execute() async throws -> User
}
