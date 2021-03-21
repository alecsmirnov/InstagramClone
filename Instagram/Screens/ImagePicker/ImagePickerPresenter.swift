//
//  ImagePickerPresenter.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

final class ImagePickerPresenter {
    // MARK: Properties
    
    weak var view: ImagePickerViewControllerProtocol?
    weak var coordinator: ImagePickerCoordinatorProtocol?
    
    var imagesService: LocalImagesServiceProtocol?
}

// MARK: - ImagePickerView Output

extension ImagePickerPresenter: ImagePickerViewControllerOutputProtocol {
    func viewDidLoad() {
        guard !(imagesService?.isEmpty ?? true) else {
            view?.showNoImagesHeader()
            view?.disableNextButton()
            
            return
        }
        
        guard let imageSize = view?.imageSize else { return }
        
        imagesService?.fetchImagesDescendingByDate(targetSize: imageSize) { [weak self] images in
            self?.appendImages(images)
        }
    }
    
    func didRequestImage() {
        guard let imageSize = view?.imageSize else { return }
        
        imagesService?.requestNextImages(targetSize: imageSize) { [weak self] images in
            self?.appendImages(images)
        }
    }
    
    func didSelectImage(at index: Int) {
        view?.disableNextButton()
        
        imagesService?.getMaximumSizeImage(at: index) { [weak self] image in
            guard let image = image else { return }
            
            self?.view?.setHeaderImage(image)
            self?.view?.enableNextButton()
        }
    }
    
    func didTapCloseButton() {
        coordinator?.closeImagePickerViewController()
    }
    
    func didTapNextButton(withImage image: UIImage) {
        coordinator?.showSharePostViewController(withImage: image)
    }
}

// MARK: - Private Methods

private extension ImagePickerPresenter {
    func appendImages(_ images: [UIImage]?) {
        guard let images = images else { return }

        view?.appendImages(images)
        view?.insertNewItems(count: images.count)
    }
}
