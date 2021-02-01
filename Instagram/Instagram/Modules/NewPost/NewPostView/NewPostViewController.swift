//
//  NewPostViewController.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

protocol INewPostViewController: AnyObject {
    func appendCellMediaFile(_ mediaFile: MediaFileType)
    func setOriginalMediaFile(_ mediaFile: MediaFileType)
    
    func enableContinueButton()
    func disableContinueButton()
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
    func appendCellMediaFile(_ mediaFile: MediaFileType) {
        customView?.appendCellMediaFile(mediaFile)
    }
    
    func setOriginalMediaFile(_ mediaFile: MediaFileType) {
        customView?.setOriginalMediaFile(mediaFile)
    }
    
    func enableContinueButton() {
        changeContinueButtonStatus(isEnabled: true)
    }
    
    func disableContinueButton() {
        changeContinueButtonStatus(isEnabled: false)
    }
}

// MARK: - NewPostViewDelegate

extension NewPostViewController: NewPostViewDelegate {
    func newPostViewDidRequestCellMedia(_ newPostView: NewPostView) {
        presenter?.didRequestCellMedia()
    }
    
    func newPostViewDidRequestOriginalMedia(_ newPostView: NewPostView, at index: Int) {
        presenter?.didRequestOriginalMedia(at: index)
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
        let continueButton = UIButton(type: .system)
        let continueBarButtonItem = UIBarButtonItem(customView: continueButton)
        
        continueButton.setImage(NewPostConstants.Images.continueButton, for: .normal)
        continueButton.addTarget(self, action: #selector(didPressContinueButton), for: .touchUpInside)

        navigationItem.rightBarButtonItem = continueBarButtonItem
        
        changeContinueButtonStatus(isEnabled: false)
    }
    
    func changeContinueButtonStatus(isEnabled: Bool) {
        let continueButton = navigationItem.rightBarButtonItem
        
        continueButton?.isEnabled = isEnabled
        
        UIView.animate(withDuration: NewPostConstants.Constants.continueButtonAnimationDuration) {
            continueButton?.customView?.alpha = isEnabled ?
                NewPostConstants.Constants.continueButtonEnableAlpha :
                NewPostConstants.Constants.continueButtonDisableAlpha
        }
    }
}

// MARK: - Actions

private extension NewPostViewController {
    @objc func didPressCloseButton() {
        presenter?.didPressCloseButton()
    }
    
    @objc func didPressContinueButton() {
        presenter?.didPressContinueButton(with: customView?.selectedMediaFile)
    }
}
