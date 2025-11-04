//
//  View+hideKeyboard.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 17/10/25.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared
                .sendAction(
                    #selector(
                        UIResponder.resignFirstResponder
                    ),
                    to: nil,
                    from: nil,
                    for: nil
                )
        }
    }
}
