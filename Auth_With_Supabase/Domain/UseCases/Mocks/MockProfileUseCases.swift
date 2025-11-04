//
//  MockProfileUseCases.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 1/8/25.
//

import Foundation

/// Mock and dummy implementations of profile-related UseCases for testing and previews.
/// `MockFetchProfileUseCase` supports controlled results via `Result<Profile, Error>`.
/// Other dummies return mock data or perform no operations, ideal for previews and unit tests.

final class MockFetchProfileUseCase: FetchProfileUseCaseProtocol {
    private let result: Result<Profile, Error>
    
    init(result: Result<Profile, Error>) {
        self.result = result
    }
    
    func execute(userId: UUID) async throws -> Profile {
        switch result {
        case .success(let profile): return profile
        case .failure(let error): throw error
        }
    }
}

final class DummyUpdateProfileUseCase: UpdateProfileUseCaseProtocol {
    func execute(_ profile: Profile, newAvatarData: Data?) async throws -> Profile {
        Profile.mock
    }
}

final class DummyCreateProfileUseCase: CreateProfileUseCaseProtocol {
    func execute(userId: UUID, email: String, username: String, avatarData: Data?) async throws {
        // no-op
    }
}

final class DummyDeleteProfileUseCase: DeleteProfileUseCaseProtocol {
    func execute(userId: UUID) async throws {}
}
