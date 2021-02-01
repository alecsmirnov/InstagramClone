//
//  UploadPostViewController.swift
//  Instagram
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol IUploadPostViewController: AnyObject {
    
}

final class UploadPostViewController: CustomViewController<UploadPostView> {
    // MARK: Properties
    
    var presenter: IUploadPostPresenter?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IUploadPostViewController

extension UploadPostViewController: IUploadPostViewController {
    
}
