//
//  ImagePickerViewController.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

protocol ImagePickerViewControllerProtocol: AnyObject {
    var imageSize: CGSize { get }
    
    func setHeaderImage(_ image: UIImage)
    func appendImages(_ images: [UIImage])
    
    func getHeaderImage() -> UIImage?
    
    func insertNewItems(count: Int)
    
    func showNoImagesHeader()
    func enableNextButton()
    func disableNextButton()
}

protocol ImagePickerViewControllerOutputProtocol: AnyObject {
    func viewDidLoad()
    
    func didRequestImage()
    func didSelectImage(at index: Int)
    
    func didTapCloseButton()
    func didTapNextButton(withImage image: UIImage)
}

final class ImagePickerViewController: CustomViewController<ImagePickerView> {
    // MARK: Properties
    
    var output: ImagePickerViewControllerOutputProtocol?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: Constants
    
    private enum Metrics {
        static let nextButtonFontSize: CGFloat = 17.5
    }
    
    private enum Images {
        static let close = AppConstants.Images.close
    }
    
    private enum Constants {
        static let nextButtonAnimationDuration: TimeInterval = 0.4
        static let nextButtonEnableAlpha: CGFloat = 1
        static let nextButtonDisableAlpha: CGFloat = 0.8
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.output = self
        
        setupAppearance()
        
        output?.viewDidLoad()
    }
}

// MARK: - ImagePickerViewController Interface

extension ImagePickerViewController: ImagePickerViewControllerProtocol {
    var imageSize: CGSize {
        customView?.cellSize ?? .zero
    }
    
    func setHeaderImage(_ image: UIImage) {
        customView?.setHeaderImage(image)
    }
    
    func appendImages(_ images: [UIImage]) {
        customView?.appendImages(images)
    }
    
    func getHeaderImage() -> UIImage? {
        return customView?.getHeaderImage()
    }
    
    func insertNewItems(count: Int) {
        customView?.insertNewItems(count: count)
    }
    
    func showNoImagesHeader() {
        customView?.showNoImagesHeader()
    }
    
    func enableNextButton() {
        changeNextButtonStatus(isEnabled: true)
    }
    
    func disableNextButton() {
        changeNextButtonStatus(isEnabled: false)
    }
}

// MARK: - ImagePickerView Output

extension ImagePickerViewController: ImagePickerViewOutputProtocol {
    func didRequestImage() {
        output?.didRequestImage()
    }
    
    func didSelectImage(at index: Int) {
        output?.didSelectImage(at: index)
    }
}

// MARK: - Appearance

private extension ImagePickerViewController {
    func setupAppearance() {
        navigationItem.title = "New post"
        
        setupCloseButton()
        setupNextButton()
    }
    
    func setupCloseButton() {
        let closeBarButtonItem = UIBarButtonItem(
            image: Images.close,
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton))
        
        closeBarButtonItem.tintColor = .black

        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    func setupNextButton() {
        let nextButton = UIButton(type: .system)
        let nextBarButtonItem = UIBarButtonItem(customView: nextButton)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: Metrics.nextButtonFontSize)
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = nextBarButtonItem
    }
    
    func changeNextButtonStatus(isEnabled: Bool) {
        let nextButton = navigationItem.rightBarButtonItem
        nextButton?.isEnabled = isEnabled
        
        UIView.animate(withDuration: Constants.nextButtonAnimationDuration) {
            nextButton?.customView?.alpha = isEnabled ?
                Constants.nextButtonEnableAlpha :
                Constants.nextButtonDisableAlpha
        }
    }
}

// MARK: - Button Actions

private extension ImagePickerViewController {
    @objc func didTapCloseButton() {
        output?.didTapCloseButton()
    }
    
    @objc func didTapNextButton() {
        guard let image = customView?.getHeaderImage() else { return }
        
        output?.didTapNextButton(withImage: image)
    }
}
