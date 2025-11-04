//
//  String+sha256.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 6/10/25.
//

import Foundation
import CryptoKit

/// Computes the SHA-256 hash of the string and returns it as a hexadecimal string.
/// Commonly used for generating unique cache keys or file names.

extension String {
    var sha256: String {
        let data = Data(self.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
