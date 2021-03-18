//
//  FollowersFollowingCollectionViewDelegate.swift
//  Instagram
//
//  Created by Admin on 18.03.2021.
//

import UIKit

final class FollowersFollowingCollectionViewDelegate: NSObject {
    var selectCellAtIndexCompletion: ((Int) -> Void)?
    var willDisplayCellAtIndexCompletion: ((UserFollowerCell, Int) -> Void)?
}

// MARK: - UICollectionViewDelegate

extension FollowersFollowingCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCellAtIndexCompletion?(indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let cell = cell as? UserFollowerCell else { return }
        
        willDisplayCellAtIndexCompletion?(cell, indexPath.row)
    }
}

