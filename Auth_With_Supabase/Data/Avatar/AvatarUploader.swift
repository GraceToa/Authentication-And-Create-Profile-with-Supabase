//
//  AvatarUploader.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 29/7/25.
//


import Foundation
import Supabase

/// Manages upload and deletion of avatar images in the Supabase "avatars" bucket.
/// Generates unique filenames and returns public URLs for stored images.
/// Provides helper methods for URL-to-path conversion and MIME detection.

struct AvatarUploader: AvatarUploaderProtocol {
    
    private let client: SupabaseClient
    private let bucket = "avatars"
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    func upload(
        imageData: Data,
        userId: UUID
    ) async throws -> String {
        let ext  = imageData.isPNG ? "png" : "jpeg"
        let fileName = "\(userId)-\(UUID().uuidString).\(ext)"
        let path = fileName
        _ = try await client.storage
            .from(
                bucket
            )
            .upload(
                path,
                data: imageData,
                options: FileOptions(
                    contentType: imageData.mimeType,
                    upsert: false
                )
            )
        
        return try client.storage
            .from(
                bucket
            )
            .getPublicURL(
                path: path
            ).absoluteString
    }
    
    func delete(byURL url: String) async throws {
        let path = try pathFromPublicURL(url)
        do {
            try await client.storage.from(bucket).remove(paths: [path])
        } catch {
            throw error
        }
    }
    
    // MARK: - Private helpers
    private func pathFromPublicURL(_ urlString: String) throws -> String {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let pattern = "/storage/v1/object/public/\(bucket)/"
        
        guard let range = url.absoluteString.range(of: pattern) else {
            throw URLError(.badURL)
        }
        
        var path = String(url.absoluteString[range.upperBound...])
        if path.hasPrefix("public/") {
            path.removeFirst("public/".count)
        }
        if path.hasPrefix("/") {
            path.removeFirst()
        }
        
        guard !path.isEmpty else { throw URLError(.badURL) }
        return path
    }
}

private extension Data {
    var isPNG: Bool { self.starts(with: [0x89, 0x50, 0x4E, 0x47]) }
    var mimeType: String { isPNG ? "image/png" : "image/jpeg" }
}
