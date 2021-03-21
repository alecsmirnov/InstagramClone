//
//  HomeCollectionViewDelegate.swift
//  Instagram
//
//  Created by Admin on 21.03.2021.
//

import UIKit

final class HomeCollectionViewDelegate: NSObject {
    var willDisplayCellAtIndexCompletion: ((PostCell, Int) -> Void)?
}

// MARK: - UICollectionViewDelegate

extension HomeCollectionViewDelegate: UICollectionViewDelegate {    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let cell = cell as? PostCell else { return }
        
        willDisplayCellAtIndexCompletion?(cell, indexPath.row)
    }
}
