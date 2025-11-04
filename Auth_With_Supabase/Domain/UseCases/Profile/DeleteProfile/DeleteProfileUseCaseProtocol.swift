//
//  DeleteProfileUseCaseProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 17/10/25.
//
import Foundation

protocol DeleteProfileUseCaseProtocol {
    func execute(userId: UUID) async throws
}
