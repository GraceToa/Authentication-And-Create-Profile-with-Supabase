//
//  MockFactory.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 24/7/25.
//

/// Mock implementation of `ViewModelFactoryProtocol` for Previews and Unit Tests.
/// Mirrors the real factory’s API (including `with(imageLoader:)`).
/// Uses mock and dummy UseCases to avoid real network or Supabase calls.
/// Ensures consistent behavior between production and testing environments.

@MainActor
final class MockViewModelFactory: ViewModelFactoryProtocol {
    
    private let authResult: Result<User, Error>
    private let profileResult: Result<Profile, Error>
    private let imageLoader: ImageLoaderProtocol?
    
    
    init(authResult: Result<User, Error>, profileResult: Result<Profile, Error>, imageLoader: ImageLoaderProtocol? = nil) {
        self.authResult = authResult
        self.profileResult = profileResult
        self.imageLoader = imageLoader
    }
    
    convenience init() {
        let dummyUser = User.mock
        let dummyProfile = Profile.mock
        self.init(authResult: .success(dummyUser),
                  profileResult: .success(dummyProfile))
    }
    
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(
            signInUseCase: MockSignInUseCase(result: authResult),
            getCurrentUserUseCase: MockUserCurrentUseCase(result: authResult),
            signOutUseCase: DummySignOutUseCase()
        )
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            fetchProfileUseCase: MockFetchProfileUseCase(result: profileResult),
            updateProfileUseCase: DummyUpdateProfileUseCase(),
            createProfileUseCase: DummyCreateProfileUseCase(),
            deleteProfileUseCase: DummyDeleteProfileUseCase(),
            imageLoader: imageLoader
        )
    }
    
    func makeSignUpViewModel(mode: SignUpMode) -> SignUpViewModel {
        SignUpViewModel(coordinatorSignUp: DummySignUpCoordinator(), mode: mode)
    }
}

// MARK: - Builder
extension MockViewModelFactory {
    func with(imageLoader: ImageLoaderProtocol) -> MockViewModelFactory {
        MockViewModelFactory(
            authResult: authResult,
            profileResult: profileResult,
            imageLoader: imageLoader
        )
    }
}
