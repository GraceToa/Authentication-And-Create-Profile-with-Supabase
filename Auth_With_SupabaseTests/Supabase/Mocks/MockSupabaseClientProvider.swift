//
//  MockSupabaseClientProvider.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 31/7/25.
//

import Foundation
import Supabase

@testable import Auth_With_Supabase

/// Mock implementation of `SupabaseClientProviderProtocol` for testing.
/// Provides a preconfigured mock `SupabaseClient` without real network interaction.
/// Used in unit tests to isolate repositories and use cases from Supabase SDK behavior.

final class MockSupabaseClientProvider: SupabaseClientProviderProtocol {
    let client: SupabaseClient
    
    init() {
        self.client = SupabaseClient(
            supabaseURL: URL(string: "https://mock.supabase.co")!,
            supabaseKey: "mock-anon-key"
        )
    }
}
