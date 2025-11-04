//
//  CompositeAvatarCache.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 6/10/25.
//

import Foundation

/// Combines memory and disk caches for avatar images.
/// Promotes disk hits to memory for faster subsequent access.
/// Ensures efficient and persistent image caching across sessions.

public struct CompositeAvatarCache: AvatarCacheProtocol {
    
    private let memory: AvatarCacheProtocol
    private let disk: AvatarCacheProtocol
    
    init(
        memory: AvatarCacheProtocol,
        disk: AvatarCacheProtocol
    ) {
        self.memory = memory
        self.disk = disk
    }
    
    public func get(for key: String) async -> Data? {
        if let memoryData = await memory.get(for: key) {
            return memoryData
        }
        
        if let diskData = await disk.get(for: key) {
            await memory.set(diskData, for: key)
            return diskData
        }
        
        return nil
    }
    
    public func set(_ data: Data, for key: String) async {
        await memory.set(data, for: key)
        await disk.set(data, for: key)
    }
    
    public func remove(for key: String) async {
        await memory.remove(for: key)
        await disk.remove(for: key)
    }
}
