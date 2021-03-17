//
//  ProfileCollectionViewDataSource.swift
//  Instagram
//
//  Created by Admin on 16.03.2021.
//

import UIKit

final class ProfileCollectionViewDataSource: NSObject {
    // MARK: Properties
    
    var lastCellPresentedCompletion: (() -> Void)?
    
    var postsCount: Int {
        return posts.count
    }
    
    private var initialUser: User?
    private var initialUserStats: UserStats?
    
    private var posts: [Post] = []
}

// MARK: - Public Methods

extension ProfileCollectionViewDataSource {
    func setInitialUser(_ user: User) {
        initialUser = user
    }
    
    func setInitialUserStats(_ userStats: UserStats) {
        initialUserStats = userStats
    }
    
    func insertFirstPost(_ post: Post) {
        posts.insert(post, at: 0)
    }
    
    func appendPost(_ post: Post) {
        posts.append(post)
    }

    func appendPosts(_ posts: [Post]) {
        self.posts.append(contentsOf: posts)
    }
    
    func getPost(at index: Int) -> Post? {
        guard posts.indices.contains(index) else { return nil }
        
        return posts[index]
    }
    
    func removeAllPosts() {
        posts.removeAll()
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DownloadImageCell.reuseIdentifier,
            for: indexPath) as? DownloadImageCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: posts[indexPath.row].imageURL)
        
        if indexPath.row == posts.count - 1 {
            lastCellPresentedCompletion?()
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileHeaderView.reuseIdentifier,
            for: indexPath) as? ProfileHeaderView
        else {
            return UICollectionReusableView()
        }
        
        if let initialUser = initialUser {
            headerView.setUser(initialUser)
        }
        
        if let initialUserStats = initialUserStats {
            headerView.setUserStats(initialUserStats)
        }
        
        return headerView
    }
}
