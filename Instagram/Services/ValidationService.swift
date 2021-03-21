//
//  ValidationService.swift
//  Instagram
//
//  Created by Admin on 19.01.2021.
//

import Foundation

enum ValidationService {
    // MARK: Properties
    
    static let passwordLengthMin = 6
}

// MARK: - Public Methods

extension ValidationService {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._-]+@[A-Z0-9a-z]+\\.[A-Za-z]{2,6}"
        let isValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        
        return isValid
    }
    
    static func isValidUsername(_ username: String) -> Bool {
        let usernameRegex = "[A-Z0-9a-z._]+"
        let isValid = NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: username)
        
        return isValid
    }
}
