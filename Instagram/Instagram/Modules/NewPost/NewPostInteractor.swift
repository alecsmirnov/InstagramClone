//
//  NewPostInteractor.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostInteractor: AnyObject {
    func fetchMediaFiles() -> [MediaFileType]
    func fetchMediaFilesAsync()
}

protocol INewPostInteractorOutput: AnyObject {
    func fetchMediaFileSuccess(_ mediaFile: MediaFileType)
}

final class NewPostInteractor {
    weak var presenter: INewPostInteractorOutput?
}

// MARK: - INewPostInteractor

extension NewPostInteractor: INewPostInteractor {
    func fetchMediaFiles() -> [MediaFileType] {
        return MediaService.fetchImages()
    }
    
    func fetchMediaFilesAsync() {
        MediaService.fetchImagesAsync { [self] mediaFile in
            presenter?.fetchMediaFileSuccess(mediaFile)
        }
    }
}
