//
//  TimeoutAlert.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

import UIKit

final class TimeoutAlert: NSObject {
    // MARK: Properties
    
    private weak var presentationController: UIViewController?
    
    private lazy var alertController: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        return alertController
    }()
    
    // MARK: Initialization
    
    init(presentationController: UIViewController) {
        super.init()

        self.presentationController = presentationController
    }
}

// MARK: - Public Methods

extension TimeoutAlert {
    func showAlert(title: String?, message: String?, timeout: TimeInterval) {
        alertController.title = title
        alertController.message = message
            
        presentationController?.present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
                guard self?.presentationController?.presentedViewController == self?.alertController else { return }

                self?.presentationController?.dismiss(animated: true)
            }
        }
    }
}
