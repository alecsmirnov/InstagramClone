//
//  EditProfileBioPresenter.swift
//  Instagram
//
//  Created by Admin on 08.03.2021.
//

protocol IEditProfileBioPresenter: AnyObject {
    func viewDidLoad()
    
    func didPressCloseButton()
    func didPressEditButton(with bio: String?)
}

protocol EditProfileBioPresenterDelegate: AnyObject {
    func editProfileBioPresenter(_ editProfileBioPresenter: EditProfileBioPresenter, didChangeBio bio: String?)
}

final class EditProfileBioPresenter {
    // MARK: Properties
    
    weak var viewController: IEditProfileBioViewController?
    var router: IEditProfileBioRouter?
    
    var bio: String?
    weak var delegate: EditProfileBioPresenterDelegate?
    
    // MARK: Constants
    
    private enum Constants {
        static let characterLimit = 150
    }
}

// MARK: - IEditProfileBioPresenter

extension EditProfileBioPresenter: IEditProfileBioPresenter {
    func viewDidLoad() {
        viewController?.setBio(bio)
        viewController?.setCharacterLimit(Constants.characterLimit)
    }
    
    func didPressCloseButton() {
        router?.closeEditProfileBioViewController()
    }
    
    func didPressEditButton(with bio: String?) {
        if bio != self.bio {
            delegate?.editProfileBioPresenter(self, didChangeBio: bio)
        }
        
        router?.closeEditProfileBioViewController()
    }
}
