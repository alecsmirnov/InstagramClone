//
//  NewPostInteractor.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostInteractor: AnyObject {
    func fetchCellMedia()
    func fetchOriginalMedia(at index: Int)
}

protocol INewPostInteractorOutput: AnyObject {
    func fetchCellMediaSuccess(_ mediaFile: MediaFileType)
    func fetchOriginalMediaSuccess(_ mediaFile: MediaFileType, at index: Int)
}

final class NewPostInteractor {
    // MARK: Properties
    
    weak var presenter: INewPostInteractorOutput?
    
    private var mediaService = MediaService()
}

// MARK: - INewPostInteractor

extension NewPostInteractor: INewPostInteractor {
    func fetchCellMedia() {
        mediaService.fetchNextImage(targetSize: NewPostConstants.Metrics.gridCellSize) { [weak self] mediaFile in
            guard let mediaFile = mediaFile else { return }
            
            self?.presenter?.fetchCellMediaSuccess(mediaFile)
        }
    }
    
    func fetchOriginalMedia(at index: Int) {
        mediaService.fetchImage(at: index) { [weak self] mediaFile in
            guard let mediaFile = mediaFile else { return }
            
            self?.presenter?.fetchOriginalMediaSuccess(mediaFile, at: index)
        }
    }
}
