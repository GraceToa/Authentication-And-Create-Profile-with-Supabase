//
//  AvatarCacheProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 6/10/25.
//

import SwiftUI

protocol AvatarCacheProtocol {
    func get(for key: String) async -> Data?
    func set(_ data:Data, for key: String) async
    func remove(for key: String) async
}
