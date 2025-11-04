//
//  DiskAvatarCache.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 6/10/25.
//

import Foundation

/// Provides persistent avatar caching on disk using the device’s cache directory.
/// Stores data as hashed filenames (`SHA256`) to avoid collisions.
/// Supports async read/write/remove operations for safe background access.
/// Complements in-memory cache to ensure data persistence across app sessions.

public final class DiskAvatarCache: AvatarCacheProtocol {
    
    private let fileManager: FileManager
    private let directory: URL
    
    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let base = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("AvatarCache", isDirectory: true)
        try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        self.directory = dir
    }
    
    func get(for key: String) async -> Data? {
        let url = directory.appendingPathComponent(key.sha256)
        return try? Data(contentsOf: url)
    }
    
    func set(_ data: Data, for key: String) async {
        let url = directory.appendingPathComponent(key.sha256)
        try? data.write(to: url, options: .atomic)
    }
    
    func remove(for key: String) async {
        try? FileManager.default.removeItem(atPath: "\(directory)/\(key.sha256)")
    }
}
