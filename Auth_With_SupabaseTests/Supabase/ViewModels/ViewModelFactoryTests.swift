//
//  ViewModelFactoryTests.swift
//  Auth_With_SupabaseTests
//
//  Created by Grace Toa on 9/10/25.
//

import XCTest
@testable import Auth_With_Supabase

final class ViewModelFactoryTests: XCTestCase {
    
    @MainActor func test_withImageLoader_returnsNewInstance() {
        let factory = ViewModelFactory(
            signUpUseCase: MockSignUpUseCase(result: .success(User.mock)),
            signInUseCase: MockSignInUseCase(result: .success(User.mock)),
            getCurrentUserUseCase: MockUserCurrentUseCase(result: .success(User.mock)),
            signOutUseCase: DummySignOutUseCase(),
            createProfileUseCase: DummyCreateProfileUseCase(),
            fetchProfileUseCase: MockFetchProfileUseCase(result: .success(Profile.mock)),
            updateProfileUseCase: DummyUpdateProfileUseCase(),
            deleteProfileUseCase: DummyDeleteProfileUseCase()
        )
        
        let mockLoaderA = MockImageLoader(id: "A")
        let mockLoaderB = MockImageLoader(id: "B")
        
        let factoryWithA = factory.with(imageLoader: mockLoaderA)
        let factoryWithB = factory.with(imageLoader: mockLoaderB)
        
        let vmA = factoryWithA.makeProfileViewModel()
        let vmB = factoryWithB.makeProfileViewModel()
        
        XCTAssertFalse(vmA === vmB)
        
    }
    
}
