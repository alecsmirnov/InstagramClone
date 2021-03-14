//
//  ImagePickerPresenter.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

final class ImagePickerPresenter {
    weak var view: ImagePickerViewControllerProtocol?
    weak var coordinator: NewPostCoordinatorProtocol?
    
    private let imagesService = LocalImagesService()
    
    // TODO: Remove
    private var images: [UIImage] = []
    
    private enum Constants {
        static let count = 4
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
        
        imagesService.fetchNextImage(targetSize: imageSize) { [weak self] image in
            guard let image = image else { return }
            
            self?.view?.appendImage(image)
            self?.view?.insertNewItem()
            
            // TODO: Remove
            //self?.images.append(image)
        }
        
        // TODO: Remove
//        if images.count == Constants.count {
//            view?.appendImages(images)
//            view?.insertNewItems(count: images.count)
//            
//            images.removeAll()
//        }
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
