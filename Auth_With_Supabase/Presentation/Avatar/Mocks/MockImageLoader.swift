//
//  MockImageLoader.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 9/10/25.
//

import Foundation

class MockImageLoader: ImageLoaderProtocol {
    
    let id: String
    
    init(id: String) { self.id = id }
    
    func load(_ url: URL) async throws -> Data {
        Data(id.utf8)
    }
    
    func invalidate(_ url: URL) async {}
}

extension MockImageLoader: Equatable {
    static func == (lhs: MockImageLoader, rhs: MockImageLoader) -> Bool {
        lhs.id == rhs.id
    }
}
