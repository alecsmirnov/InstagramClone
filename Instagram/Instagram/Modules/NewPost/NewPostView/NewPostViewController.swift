//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

protocol INewPostViewController: AnyObject {
    func appendMediaFile(_ mediaFile: MediaFileType)
    
    func setHeaderMediaFile(_ mediaFile: MediaFileType)
}

final class NewPostViewController: CustomViewController<NewPostView> {
    // MARK: Properties
    
    var presenter: INewPostPresenter?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
        
        setupAppearance()
    }
}

// MARK: - INewPostViewController

extension NewPostViewController: INewPostViewController {
    func appendMediaFile(_ mediaFile: MediaFileType) {
        customView?.appendMediaFile(mediaFile)
    }
    
    func setHeaderMediaFile(_ mediaFile: MediaFileType) {
        customView?.setHeaderMediaFile(mediaFile)
    }
}

// MARK: - NewPostViewDelegate

extension NewPostViewController: NewPostViewDelegate {
    func newPostViewDidRequestMedia(_ newPostView: NewPostView) {
        presenter?.didRequestMedia()
    }
    
    func newPostViewDidSelectMedia(_ newPostView: NewPostView, atIndex index: Int) {
        presenter?.didSelectMedia(atIndex: index)
    }
}

// MARK: - Appearance

private extension NewPostViewController {
    func setupAppearance() {
        navigationItem.title = NewPostConstants.Constants.title
        
        setupCloseButton()
        setupContinueButton()
    }
    
    func setupCloseButton() {
        let closeBarButtonItem = UIBarButtonItem(
            image: NewPostConstants.Images.closeButton,
            style: .plain,
            target: self,
            action: #selector(didPressCloseButton))
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    func setupContinueButton() {
        let continueBarButtonItem = UIBarButtonItem(
            image: NewPostConstants.Images.continueButton,
            style: .plain,
            target: self,
            action: #selector(didPressContinueButton))
        
        navigationItem.rightBarButtonItem = continueBarButtonItem
    }
}

// MARK: - Actions

private extension NewPostViewController {
    @objc func didPressCloseButton() {
        presenter?.didPressCloseButton()
    }
    
    @objc func didPressContinueButton() {
        presenter?.didPressContinueButton()
    }
}
