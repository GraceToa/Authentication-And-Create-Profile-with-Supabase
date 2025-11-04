//
//  ProfileViewModelTest.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 4/8/25.
//

import XCTest
@testable import Auth_With_Supabase

@MainActor
final class ProfileViewModelTest: XCTestCase {
    
    let expectedProfile = Profile.mock
    
    func test_load_success_setsProfile() async {
        
        let factory = MockViewModelFactory(
            authResult: .success(User.mock),
            profileResult: .success(expectedProfile)
        )
        
        let viewModel = factory.makeProfileViewModel()
        
        await viewModel.loadIfNeeded(userId: expectedProfile.id)
        
        XCTAssertEqual(viewModel.profile?.fullName, "Test User")
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_load_failure_setsProfile() async {
        
        let factory = MockViewModelFactory(
            authResult: .success(User.mock),
            profileResult: .failure(ProfileError.notFound)
        )
        
        let viewModel = factory.makeProfileViewModel()
        
        await viewModel.loadIfNeeded(userId: UUID())
        
        XCTAssertNil(viewModel.profile)
        XCTAssertNil(viewModel.errorMessage)
    }
}
