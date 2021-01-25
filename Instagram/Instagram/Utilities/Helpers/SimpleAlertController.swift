//
//  SimpleAlert.swift
//  Instagram
//
//  Created by Admin on 25.01.2021.
//

import UIKit

final class SimpleAlert: NSObject {
    // MARK: Properties
    
    private weak var presentationController: UIViewController?
    
    private lazy var alertController: UIAlertController = {
        let alertAction = UIAlertAction(title: "Dismiss", style: .cancel)
        alertAction.setValue(LoginRegistrationColors.alertActionButton, forKey: "titleTextColor")

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.addAction(alertAction)
        
        return alertController
    }()
    
    // MARK: Initialization
    
    init(presentationController: UIViewController) {
        super.init()

        self.presentationController = presentationController
    }
}

extension SimpleAlert {
    func showAlert(title: String?, message: String?) {
        alertController.title = title
        alertController.message = message
        
        presentationController?.present(alertController, animated: true)
    }
}
