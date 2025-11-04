//
//  ImageLoaderProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 7/10/25.
//

import Foundation

public protocol ImageLoaderProtocol {
    func load(_ url: URL) async throws -> Data
    func invalidate(_ url: URL) async
}
