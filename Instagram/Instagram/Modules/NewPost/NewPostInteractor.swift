//
//  NewPostInteractor.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostInteractor: AnyObject {
    func fetchMedia()
    func fetchMedia(at index: Int)
}

protocol INewPostInteractorOutput: AnyObject {
    func fetchMediaSuccess(_ mediaFile: MediaFileType)
    func fetchMediaSuccess(_ mediaFile: MediaFileType, at index: Int)
}

final class NewPostInteractor {
    // MARK: Properties
    
    weak var presenter: INewPostInteractorOutput?
    
    private var mediaService = MediaService()
}

// MARK: - INewPostInteractor

extension NewPostInteractor: INewPostInteractor {
    func fetchMedia() {        
        mediaService.fetchNextImage(targetSize: NewPostConstants.Metrics.gridCellSize) { [weak self] mediaFile in
            guard let mediaFile = mediaFile else { return }
            
            self?.presenter?.fetchMediaSuccess(mediaFile)
        }
    }
    
    func fetchMedia(at index: Int) {
        mediaService.fetchImage(at: index) { [weak self] mediaFile in
            guard let mediaFile = mediaFile else { return }
            
            self?.presenter?.fetchMediaSuccess(mediaFile, at: index)
        }
    }
}
