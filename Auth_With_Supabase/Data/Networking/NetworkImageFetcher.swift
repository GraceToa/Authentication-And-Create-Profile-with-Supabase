//
//  NetworkImageFetcher.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 7/10/25.
//

import Foundation

public struct NetworkImageFetcher: ImageFetcherProtocol {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func fetch(_ url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else {
            throw URLError(.badServerResponse)
        }        
        return data
    }
}

