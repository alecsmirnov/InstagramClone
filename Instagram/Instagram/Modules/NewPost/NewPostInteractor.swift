//
//  NewPostInteractor.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

protocol INewPostInteractor: AnyObject {
    func fetchMediaFiles() -> [MediaFileType]
}

protocol INewPostInteractorOutput: AnyObject {

}

final class NewPostInteractor {
    weak var presenter: INewPostInteractorOutput?
}

// MARK: - INewPostInteractor

extension NewPostInteractor: INewPostInteractor {
    func fetchMediaFiles() -> [MediaFileType] {
        return MediaService.fetchImages()
    }
}
