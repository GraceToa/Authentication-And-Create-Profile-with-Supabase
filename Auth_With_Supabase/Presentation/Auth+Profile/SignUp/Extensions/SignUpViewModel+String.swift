//
//  SignUpViewModel+String.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 11/8/25.
//

// MARK: - UI Helpers
extension SignUpViewModel {
    var modeTitle: String {
        switch mode {
        case .register: "Register"
        case .registerAndCreateProfile: "Register and Create Profile"
        case .createProfile: "Create your profile"
        case .edit(_):
            "Edit your profile"
        case .editProfile:
            "Edit your profile"
        }
    }
    
    var buttonTitle: String {
        switch mode {
        case .register: "Save Register"
        case .registerAndCreateProfile: "Save Register and Profile"
        case .createProfile: "Save Profile"
        case .edit(_): "Save Edits"
        case .editProfile:
            "Save your profile"
        }
    }
    
    var isEmailEditable: Bool {
        switch mode {
        case .editProfile: return false
        default: return true
        }
    }
}
