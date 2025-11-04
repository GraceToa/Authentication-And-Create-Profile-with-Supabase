//
//  ImageFetcherProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 6/10/25.
//

import Foundation

protocol ImageFetcherProtocol {
    func fetch(_ url: URL) async throws -> Data
}


