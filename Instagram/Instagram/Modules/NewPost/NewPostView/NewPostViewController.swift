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
    
    func enableNextButton()
    func disableNextButton()
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
    
    func enableNextButton() {
        changeNextButtonStatus(isEnabled: true)
    }
    
    func disableNextButton() {
        changeNextButtonStatus(isEnabled: false)
    }
}

// MARK: - NewPostViewDelegate

extension NewPostViewController: NewPostViewDelegate {
    func newPostViewDidRequestCellMediaFile(_ newPostView: NewPostView) {
        presenter?.didRequestCellMediaFile()
    }
    
    func newPostViewDidRequestOriginalMediaFile(_ newPostView: NewPostView, at index: Int) {
        presenter?.didRequestOriginalMediaFile(at: index)
    }
}

// MARK: - Appearance

private extension NewPostViewController {
    func setupAppearance() {
        navigationItem.title = NewPostConstants.Constants.title
        
        setupCloseButton()
        setupNextButton()
    }
    
    func setupCloseButton() {
        let closeBarButtonItem = UIBarButtonItem(
            image: NewPostConstants.Images.closeButton,
            style: .plain,
            target: self,
            action: #selector(didPressCloseButton))
        
        closeBarButtonItem.tintColor = .black

        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    func setupNextButton() {
        let nextButton = UIButton(type: .system)
        let nextBarButtonItem = UIBarButtonItem(customView: nextButton)
        
        nextButton.setTitle(NewPostConstants.Constants.nextButtonTitle, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: NewPostConstants.Metrics.nextButtonFontSize)
        
        nextButton.addTarget(self, action: #selector(didPressNextButton), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = nextBarButtonItem
    }
    
    func changeNextButtonStatus(isEnabled: Bool) {
        let nextButton = navigationItem.rightBarButtonItem
        
        nextButton?.isEnabled = isEnabled
        
        UIView.animate(withDuration: NewPostConstants.Constants.nextButtonAnimationDuration) {
            nextButton?.customView?.alpha = isEnabled ?
                NewPostConstants.Constants.nextButtonEnableAlpha :
                NewPostConstants.Constants.nextButtonDisableAlpha
        }
    }
}

// MARK: - Actions

private extension NewPostViewController {
    @objc func didPressCloseButton() {
        presenter?.didPressCloseButton()
    }
    
    @objc func didPressNextButton() {
        presenter?.didPressNextButton(with: customView?.selectedMediaFile)
    }
}
