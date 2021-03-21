//
//  HomeCollectionViewDataSource.swift
//  Instagram
//
//  Created by Admin on 21.03.2021.
//

import UIKit

final class HomeCollectionViewDataSource: NSObject {
    // MARK: Properties
    
    var lastCellPresentedCompletion: (() -> Void)?
    
    var usersPostsCount: Int {
        return usersPosts.count
    }
    
    private var lastRequestedPostIndex: Int?
    private var usersPosts = [UserPost]()
}

// MARK: - Public Methods

extension HomeCollectionViewDataSource {
    func appendFirstUserPost(_ userPost: UserPost) {
        usersPosts.insert(userPost, at: 0)
    }
    
    func appendUsersPosts(_ usersPosts: [UserPost]) {
        self.usersPosts.append(contentsOf: usersPosts)
    }
    
    func getUserPost(at index: Int) -> UserPost? {
        guard usersPosts.indices.contains(index) else { return nil }
        
        return usersPosts[index]
    }
    
    func removeAllUsersPosts() {
        lastRequestedPostIndex = nil
        
        usersPosts.removeAll()
    }
}

// MARK: - UICollectionViewDataSource

extension HomeCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersPosts.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCell.reuseIdentifier,
            for: indexPath) as? PostCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: usersPosts[indexPath.row])
        
        // Check for multiple function calls (show hidden cells) and
        // and the size of dynamic cell, which the collectionView defines as 44 (strange bug...)
        if indexPath.row == usersPosts.count - 1 && (lastRequestedPostIndex ?? -1) < indexPath.row {
            lastRequestedPostIndex = indexPath.row
            
            lastCellPresentedCompletion?()
        }

        return cell
    }
}
