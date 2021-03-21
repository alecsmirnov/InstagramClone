//
//  CommentsCollectionViewDataSource.swift
//  Instagram
//
//  Created by Admin on 21.03.2021.
//

import UIKit

final class CommentsCollectionViewDataSource: NSObject {
    // MARK: Properties
    
    var lastCellPresentedCompletion: (() -> Void)?
    
    var usersCommentsCount: Int {
        return usersComments.count
    }
    
    private var lastRequestedPostIndex: Int?
    private var usersComments: [UserComment] = []
}

// MARK: - Public Methods

extension CommentsCollectionViewDataSource {
    func appendUsersComments(_ usersComments: [UserComment]) {
        self.usersComments.append(contentsOf: usersComments)
    }
    
    func getUserComment(at index: Int) -> UserComment? {
        guard usersComments.indices.contains(index) else { return nil }
        
        return usersComments[index]
    }
    
    func removeAllUsersComments() {
        lastRequestedPostIndex = nil
        
        usersComments.removeAll()
    }
}

// MARK: - UICollectionViewDataSource

extension CommentsCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersComments.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CommentCell.reuseIdentifier,
            for: indexPath) as? CommentCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: usersComments[indexPath.row])
        
        // Check for multiple function calls (show hidden cells) and
        // and the size of dynamic cell, which the collectionView defines as 44 (strange bug...)
        if indexPath.row == usersComments.count - 1 && (lastRequestedPostIndex ?? -1) < indexPath.row {
            lastRequestedPostIndex = indexPath.row
            
            lastCellPresentedCompletion?()
        }

        return cell
    }
}
