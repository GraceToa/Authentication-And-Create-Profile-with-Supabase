//
//  MockFileManager.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 8/10/25.
//

import Foundation

final class MockFileManager: FileManager {
    
    private(set) var createdDirectories: [URL] = []
    private(set) var removedItems: [URL] = []
    private(set) var writtenFiles: [URL: Data] = [:]
    
    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        createdDirectories.append(url)
    }
    
    override func removeItem(at URL: URL) throws {
        removedItems.append(URL)
    }
    
    override func contents(atPath path: String) -> Data? {
        URL(fileURLWithPath: path).lastPathComponent == "exists"
        ? Data("mock-data".utf8)
        : nil
    }
    
    func write(_ data: Data, to url: URL) throws {
        writtenFiles[url] = data
    }
}
