//
//  SupabaseClientProvider.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 18/7/25.
//

import Foundation
import Supabase

/// Provides a configured instance of `SupabaseClient`.
/// Handles client initialization and reset using the provided `SupabaseConfig`.
/// Implements dependency injection for testability and separation of concerns.
/// Used as the main entry point to interact with Supabase services.

final class SupabaseClientProvider: SupabaseClientProviderProtocol {
    private let config: SupabaseConfig
    private(set) var client: SupabaseClient
    
    init(config: SupabaseConfig) {
        self.config = config
        self.client = SupabaseClient(
            supabaseURL: config.url,
            supabaseKey: config.anonKey
        )
    }
    
    func reset() {
        client = SupabaseClient(
            supabaseURL: config.url,
            supabaseKey: config.anonKey
        )
        print("♻️ SupabaseClient restarted without session in memory")
    }
}
