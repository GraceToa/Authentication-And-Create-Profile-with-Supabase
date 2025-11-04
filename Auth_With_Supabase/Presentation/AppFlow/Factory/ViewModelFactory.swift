//
//  ViewModelFactory.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 23/7/25.
//

import Foundation

/// Central factory responsible for creating ViewModels with their dependencies.
/// Implements `ViewModelFactoryProtocol` to ensure clean dependency injection.
/// Provides builder-style `.with()` for dynamic image loader assignment.
/// Promotes MVVM consistency and testability across the app.

struct ViewModelFactory: ViewModelFactoryProtocol {
    // MARK: - Use Cases
    fileprivate let signUpUseCase: SignUpUseCaseProtocol
    fileprivate let signInUseCase: SignInUseCaseProtocol
    fileprivate let getCurrentUserUseCase: UserCurrentUseCaseProtocol
    fileprivate let signOutUseCase: SignOutUseCaseProtocol
    fileprivate let createProfileUseCase: CreateProfileUseCaseProtocol
    fileprivate let fetchProfileUseCase: FetchProfileUseCaseProtocol
    fileprivate let updateProfileUseCase: UpdateProfileUseCaseProtocol
    fileprivate let deleteProfileUseCase: DeleteProfileUseCaseProtocol
    fileprivate var imageLoader: ImageLoaderProtocol?
    
    // MARK: - Init
    init(
        signUpUseCase: SignUpUseCaseProtocol,
        signInUseCase: SignInUseCaseProtocol,
        getCurrentUserUseCase: UserCurrentUseCaseProtocol,
        signOutUseCase: SignOutUseCaseProtocol,
        createProfileUseCase: CreateProfileUseCaseProtocol,
        fetchProfileUseCase: FetchProfileUseCaseProtocol,
        updateProfileUseCase: UpdateProfileUseCaseProtocol,
        deleteProfileUseCase: DeleteProfileUseCaseProtocol,
        imageLoader: ImageLoaderProtocol? = nil
    ) {
        self.signUpUseCase = signUpUseCase
        self.signInUseCase = signInUseCase
        self.getCurrentUserUseCase = getCurrentUserUseCase
        self.signOutUseCase = signOutUseCase
        self.createProfileUseCase = createProfileUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.deleteProfileUseCase = deleteProfileUseCase
        self.imageLoader = imageLoader
    }
    
    // MARK: - Factories
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(
            signInUseCase: signInUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
            signOutUseCase: signOutUseCase
        )
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            fetchProfileUseCase: fetchProfileUseCase,
            updateProfileUseCase: updateProfileUseCase,
            createProfileUseCase: createProfileUseCase,
            deleteProfileUseCase: deleteProfileUseCase,
            imageLoader: imageLoader
        )
    }
    
    func makeSignUpViewModel(mode: SignUpMode) -> SignUpViewModel {
        let coordinatorSignUp = SignUpCoordinator(
            signUpUseCase: signUpUseCase,
            createProfileUseCase: createProfileUseCase
        )
        return SignUpViewModel(
            coordinatorSignUp: coordinatorSignUp,
            mode: mode
        )
    }
    
}

// MARK: - Builder
extension ViewModelFactory {
    func with(imageLoader: ImageLoaderProtocol) -> ViewModelFactory {
        ViewModelFactory(
            signUpUseCase: signUpUseCase,
            signInUseCase: signInUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
            signOutUseCase: signOutUseCase,
            createProfileUseCase: createProfileUseCase,
            fetchProfileUseCase: fetchProfileUseCase,
            updateProfileUseCase: updateProfileUseCase,
            deleteProfileUseCase: deleteProfileUseCase,
            imageLoader: imageLoader
        )
    }
}
