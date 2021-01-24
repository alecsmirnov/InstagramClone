//
//  CustomViewController.swift
//  Instagram
//
//  Created by Admin on 17.01.2021.
//

import UIKit

class CustomViewController<CustomView: UIView>: UIViewController {
    // MARK: Properties
    
    internal var customView: CustomView? {
        guard let view = view as? CustomView else {
            print("view is not a CustomView instance")
            
            return nil
        }
        
        return view
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        view = CustomView()
    }
}
