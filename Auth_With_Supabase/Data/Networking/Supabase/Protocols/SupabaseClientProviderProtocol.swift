//
//  SupabaseClientProviderProtocol.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 18/7/25.
//

import Supabase

protocol SupabaseClientProviderProtocol {
    var client: SupabaseClient { get }
}
