//
//  MemoryAvatarCache.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 6/10/25.
//

import Foundation

/// In-memory avatar cache using an `actor` for thread safety.
/// Stores a limited number of items defined by `maxItems`.
/// Provides fast access to recently used images without disk I/O.
/// Automatically evicts the oldest entry when the limit is reached.

public actor MemoryAvatarCache: AvatarCacheProtocol {
    
    private var store: [String: Data] = [:]
    private let maxItems: Int
    
    init( maxItems: Int = 5) {
        self.maxItems = maxItems
    }
    
    func get(for key: String) async -> Data? {
        store[key]
    }
    
    func set(_ data: Data, for key: String) async {
        store[key] = data
        if store.count > maxItems {
            store.remove(at: store.startIndex)
        }
    }
    
    func remove(for key: String) async {
        store[key] = nil
    }
}
