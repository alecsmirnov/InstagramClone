//
//  SpinnerViewController.swift
//  Instagram
//
//  Created by Admin on 04.02.2021.
//

import UIKit

final class SpinnerViewController: UIViewController {    
    // MARK: Properties
    
    var statusBarHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    private let spinnerView = SpinnerView()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(spinnerView)
    }
    
    // MARK: Initialization
    
    init(statusBarHidden: Bool = false) {
        self.statusBarHidden = statusBarHidden
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension SpinnerViewController {
    func show() {
        spinnerView.show()
    }

    func hide() {
        spinnerView.hide()
    }
}
