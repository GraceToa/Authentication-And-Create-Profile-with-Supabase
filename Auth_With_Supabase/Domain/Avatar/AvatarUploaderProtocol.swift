//
//  AvatarUploaderProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 30/7/25.
//

import Foundation

protocol AvatarUploaderProtocol {
    func upload(imageData: Data, userId: UUID) async throws -> String
    func delete(byURL url: String) async throws
}

