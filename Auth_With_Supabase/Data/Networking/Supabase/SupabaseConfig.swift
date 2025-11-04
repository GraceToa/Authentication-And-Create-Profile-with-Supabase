//
//  SupabaseConfig.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 18/7/25.
//

import Foundation

/// Loads and validates Supabase configuration from `Info.plist`.
/// Provides the `url` and `anonKey` required to initialize `SupabaseClient`.
/// Returns `nil` if configuration keys are missing or invalid.
/// Ensures safe initialization and centralized config management.

struct SupabaseConfig {
    let url: URL
    let anonKey: String
    
    init?() {
        guard let info = Bundle.main.infoDictionary else {
            return nil
        }
        
        guard let urlString = info["SUPABASE_URL"] as? String,
              let url = URL(string: urlString),
              let host = url.host else {
            return nil
        }
        
        guard let anonKey = info["SUPABASE_ANON_KEY"] as? String else {
            return nil
        }
        
        self.url = url
        self.anonKey = anonKey
    }
}
