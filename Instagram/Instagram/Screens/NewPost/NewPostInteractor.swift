//
//  NewPostInteractor.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

protocol INewPostInteractor: AnyObject {
    func fetchCellMediaFile()
    func fetchOriginalMediaFile(at index: Int)
}

protocol INewPostInteractorOutput: AnyObject {
    func fetchCellMediaFileSuccess(_ mediaFile: UIImage)
    func fetchOriginalMediaFileSuccess(_ mediaFile: UIImage, at index: Int)
}

final class NewPostInteractor {
    // MARK: Properties
    
    weak var presenter: INewPostInteractorOutput?
    
    private var mediaService = LocalImagesService()
}

// MARK: - INewPostInteractor

extension NewPostInteractor: INewPostInteractor {
    func fetchCellMediaFile() {
        mediaService.fetchNextImage(targetSize: NewPostConstants.Metrics.gridCellSize) { [weak self] mediaFile in
            guard let mediaFile = mediaFile else { return }
            
            self?.presenter?.fetchCellMediaFileSuccess(mediaFile)
        }
    }
    
    func fetchOriginalMediaFile(at index: Int) {
        mediaService.fetchImage(at: index) { [weak self] mediaFile in
            guard let mediaFile = mediaFile else { return }
            
            self?.presenter?.fetchOriginalMediaFileSuccess(mediaFile, at: index)
        }
    }
}
