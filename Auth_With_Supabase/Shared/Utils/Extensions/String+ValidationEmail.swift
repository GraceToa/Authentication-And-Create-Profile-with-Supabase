//
//  String+ValidationEmail.swift
//  Auth_With_Supabase
//
//  Created by Grace Toa on 30/7/25.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        NSPredicate(format:"SELF MATCHES %@", "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$").evaluate(with: self)
    }
}
