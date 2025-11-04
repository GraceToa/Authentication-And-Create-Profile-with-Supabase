//
//  Auth_With_SupabaseApp.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 17/7/25.
//

import SwiftUI

/// The main entry point of the application.
///
/// `YourApp` configures and launches the SwiftUI scene hierarchy.
/// It initializes the Supabase configuration, injects dependencies,
/// and builds the factory that provides all ViewModels and UseCases
/// following MVVM and SOLID principles.
///
/// - Important: This structure is annotated with `@main`,
/// which means it is the starting point of the app.
///
/// The `makeFactory(config:)` method encapsulates dependency injection,
/// ensuring a clean and testable architecture without singletons.

@main
struct YourApp: App {
    
    /// Defines the main scene for the SwiftUI app.
    /// It attempts to load the `SupabaseConfig`.
    /// If the configuration is valid, it creates all required dependencies
    /// and injects them into the `RootView`.
    var body: some Scene {
        WindowGroup {
            if let config = SupabaseConfig() {
                let factory = makeFactory(config: config)
                
                RootView(factory: factory)
            } else {
                Text("❌ Supabase config missing or invalid.")
            }
        }
    }
    
    // MARK: - Factory
    /// Builds and wires up the full dependency graph for the app.
    ///
    /// - Parameter config: The `SupabaseConfig` object containing connection details.
    /// - Returns: A concrete implementation of `ViewModelFactoryProtocol`
    ///   that provides all required ViewModels and UseCases.
    ///
    /// This method:
    /// 1. Initializes the Supabase client.
    /// 2. Configures repositories (Auth, Profile).
    /// 3. Sets up image caching layers (memory + disk).
    /// 4. Instantiates uploaders and image loaders.
    /// 5. Returns a ready-to-use `ViewModelFactory` for dependency injection.
    
    private func makeFactory(config: SupabaseConfig) -> ViewModelFactoryProtocol {
        let clientProvider = SupabaseClientProvider(config: config)
        let client = clientProvider.client
        
        // Data layer
        let authRepo = AuthRepository(provider: clientProvider)
        let profileRepo = ProfileRepository(client: client)
        
        // Storage & caching
        let avatarUploader: AvatarUploaderProtocol = AvatarUploader(client: client)
        let cache: AvatarCacheProtocol = CompositeAvatarCache(
            memory: MemoryAvatarCache(),
            disk: DiskAvatarCache()
        )
        let imageFetcher: ImageFetcherProtocol = NetworkImageFetcher()
        let imageLoader: ImageLoaderProtocol = ImageLoader(cache: cache, fetcher: imageFetcher)
        
        // UseCases + Factory
        return ViewModelFactory(
            signUpUseCase: SignUpUseCase(repository: authRepo),
            signInUseCase: SignInUseCase(repository: authRepo),
            getCurrentUserUseCase: UserCurrentUseCase(repository: authRepo),
            signOutUseCase: SignOutUseCase(repository: authRepo),
            createProfileUseCase: CreateProfileUseCase(repository: profileRepo, uploader: avatarUploader),
            fetchProfileUseCase: FetchProfileUseCase(repository: profileRepo),
            updateProfileUseCase: UpdateProfileUseCase(repository: profileRepo, uploader: avatarUploader, cache: cache),
            deleteProfileUseCase: DeleteProfileUseCase(repository: profileRepo, uploader: avatarUploader, cache: cache)
        ).with(imageLoader: imageLoader)
    }
}

