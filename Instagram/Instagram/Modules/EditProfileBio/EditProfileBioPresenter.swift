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
    weak var viewController: IEditProfileBioViewController?
    var router: IEditProfileBioRouter?
    
    var bio: String?
    weak var delegate: EditProfileBioPresenterDelegate?
}

// MARK: - IEditProfileBioPresenter

extension EditProfileBioPresenter: IEditProfileBioPresenter {
    func viewDidLoad() {
        if let bio = bio {
            viewController?.setBio(bio)
        }
        
        viewController?.setCharacterLimit(10)
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
