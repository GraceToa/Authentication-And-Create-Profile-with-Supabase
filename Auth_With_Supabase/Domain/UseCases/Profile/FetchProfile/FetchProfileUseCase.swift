//
//  FetchProfileUseCase.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 22/7/25.
//

import Foundation

/// Retrieves a user profile from the data source by ID.
/// Implements `FetchProfileUseCaseProtocol` for clear domain separation.
/// Delegates fetching logic to `ProfileRepositoryProtocol`.

class FetchProfileUseCase: FetchProfileUseCaseProtocol {
    
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: UUID) async throws -> Profile {
        try await repository.fetchProfile(userId: userId)
    }
}
