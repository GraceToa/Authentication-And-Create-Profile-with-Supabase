//
//  AvatarImageLoader.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 6/10/25.
//

import Foundation

/// Loads remote images with caching support for performance and offline access.
/// Combines an `ImageFetcherProtocol` for network retrieval and `AvatarCacheProtocol` for storage.
/// Caches successful downloads and returns cached data on subsequent requests.
/// Provides `invalidate(_:)` to remove specific images from cache when needed.
/// Promotes testability and separation of concerns through dependency injection.

public struct ImageLoader: ImageLoaderProtocol {
    
    private let cache: AvatarCacheProtocol
    private let fetcher: ImageFetcherProtocol
    
    init(
        cache: AvatarCacheProtocol,
        fetcher: ImageFetcherProtocol
    ) {
        self.cache = cache
        self.fetcher = fetcher
    }
    
    public func load(_ url: URL) async throws -> Data {
        let key = url.absoluteString
        
        if let cached = await cache.get(for: key) {
            return cached
        }
        
        let data = try await fetcher.fetch(url)
        await cache.set(data, for: key)
        return data
    }
    
    public func invalidate(_ url: URL) async {
        await cache.remove(for: url.absoluteString)
    }
}
