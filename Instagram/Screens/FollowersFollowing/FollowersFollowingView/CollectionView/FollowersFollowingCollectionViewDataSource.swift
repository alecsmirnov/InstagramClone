//
//  FollowersFollowingCollectionViewDataSource.swift
//  Instagram
//
//  Created by Admin on 18.03.2021.
//

import UIKit

final class FollowersFollowingCollectionViewDataSource: NSObject {
    // MARK: Properties
    
    var lastCellPresentedCompletion: (() -> Void)?
    
    var usersCount: Int {
        return users.count
    }
    
    var usersType: UsersType?
    
    private var users: [User] = []
    
    // MARK: Constants
    
    enum UsersType {
        case followers
        case following
        case users
    }
}

// MARK: - Public Methods

extension FollowersFollowingCollectionViewDataSource {
    func appendUsers(_ users: [User]) {
        self.users.append(contentsOf: users)
    }
    
    func getUser(at index: Int) -> User? {
        guard users.indices.contains(index) else { return nil }
        
        return users[index]
    }
    
    func removeAllUsers() {
        users.removeAll()
    }
}

// MARK: - UICollectionViewDataSource

extension FollowersFollowingCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let usersType = usersType,
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UserFollowerCell.reuseIdentifier,
                for: indexPath) as? UserFollowerCell
        else {
            return UICollectionViewCell()
        }
        
        if indexPath.row == users.count - 1 {
            lastCellPresentedCompletion?()
        }
        
        switch usersType {
        case .followers:
            cell.configureFollower(with: users[indexPath.row])
        case .following:
            cell.configureFollowing(with: users[indexPath.row])
        case .users:
            cell.configureUser(with: users[indexPath.row])
        }
        
        return cell
    }
}
