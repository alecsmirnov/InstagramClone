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
    weak var coordinator: NewPostCoordinatorProtocol?
    
    private let imagesService = LocalImagesService()
    
    // MARK: Constants
    
    private enum Requests {
        static let imagesLimit = 4
    }
}

// MARK: - ImagePickerView Output

extension ImagePickerPresenter: ImagePickerViewControllerOutputProtocol {
    func viewDidLoad() {
        guard !imagesService.isEmpty else {
            view?.disableNextButton()
            
            return
        }
        
        didRequestImage()
    }
    
    func didRequestImage() {
        guard let imageSize = view?.imageSize else { return }
        
        imagesService.fetchNextImages(targetSize: imageSize, count: Requests.imagesLimit) { [weak self] images in
            guard let images = images else { return }

            self?.view?.appendImages(images)
            self?.view?.insertNewItems(count: images.count)
        }
    }
    
    func didSelectImage(at index: Int) {
        view?.disableNextButton()
        
        imagesService.fetchImage(at: index) { [weak self] image in
            guard let image = image else { return }
            
            self?.view?.setHeaderImage(image)
            self?.view?.enableNextButton()
        }
    }
    
    func didTapCloseButton() {
        coordinator?.closeNewPostViewController()
    }
    
    func didTapNextButton(withImage image: UIImage) {
        coordinator?.showSharePostViewController(withImage: image)
    }
}
