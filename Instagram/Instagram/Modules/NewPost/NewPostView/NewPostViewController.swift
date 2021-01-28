//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

protocol INewPostViewController: AnyObject {
    
}

final class NewPostViewController: CustomViewController<NewPostView> {
    // MARK: Properties
    
    var presenter: INewPostPresenter?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - INewPostViewController

extension NewPostViewController: INewPostViewController {
    
}
