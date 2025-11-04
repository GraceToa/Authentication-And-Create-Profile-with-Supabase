//
//  SignInView+Preview.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 23/7/25.
//

import SwiftUI

struct SignInView_Previews: PreviewProvider {
        
    static var previews: some View {
        
        let factory = MockViewModelFactory()
        let signUpViewModel = factory.makeSignUpViewModel(mode: .register)
        let profileviewModel = factory.makeProfileViewModel()
        
        return SignInView(
            signUpViewModel: signUpViewModel,
            profileViewModel: profileviewModel
        )
    }
}
