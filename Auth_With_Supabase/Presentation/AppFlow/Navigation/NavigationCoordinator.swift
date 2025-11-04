//
//  NavigationCoordinator.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 23/7/25.
//

import Foundation

/// Manages app navigation state and modal presentations.
/// Implements push/pop logic for `NavigationStack` and sheet handling.
/// Uses dependency injection via `ViewModelFactoryProtocol` for ViewModel creation.
/// Ensures centralized, testable navigation control across the app.

@MainActor
final class NavigationCoordinator: ObservableObject {
    
    @Published var path: [AppRoute] = []
    @Published var presentedSheet: AppSheet?
    
    let factory: ViewModelFactoryProtocol
    
    init(factory: ViewModelFactoryProtocol) {
        self.factory = factory
    }
    
    // MARK: - PUSH
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func reset() {
        path = []
    }
    
    // MARK: - SHEET
    func showEditProfileSheet(_ profile: Profile) {
        presentedSheet = .editProfile(profile)
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
}


