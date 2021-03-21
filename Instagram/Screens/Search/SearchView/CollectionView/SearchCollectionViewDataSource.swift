//
//  SearchCollectionViewDataSource.swift
//  Instagram
//
//  Created by Admin on 15.03.2021.
//

import UIKit

final class SearchCollectionViewDataSource: NSObject {
    // MARK: Properties
    
    var lastCellPresentedCompletion: (() -> Void)?
    
    var usersCount: Int {
        return users.count
    }
    
    var state: SearchState = .result
    
    private var users: [User] = []
    
    // MARK: Constants
    
    enum SearchState {
        case search
        case noResult
        case result
    }
}

// MARK: - Public Methods

extension SearchCollectionViewDataSource {
    func appendUser(_ user: User) {
        users.append(user)
    }
    
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

extension SearchCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .search, .noResult:
            return 1
        case .result:
            return users.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch state {
        case .search, .noResult:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchCell.reuseIdentifier,
                for: indexPath) as? SearchCell
            else {
                return UICollectionViewCell()
            }

            if state == .search {
                cell.showSearchMessage()
            } else {
                cell.showNoResultMessage()
            }

            return cell
        case .result:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UserCell.reuseIdentifier,
                for: indexPath) as? UserCell
            else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: users[indexPath.row])
            
            if indexPath.row == users.count - 1 {
                lastCellPresentedCompletion?()
            }

            return cell
        }
    }
}
