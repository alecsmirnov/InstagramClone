//
//  UIViewController+add.swift
//  Instagram
//
//  Created by Admin on 04.02.2021.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        
        removeFromParent()
    }
}
