//
//  CommentsCollectionViewDelegate.swift
//  Instagram
//
//  Created by Admin on 21.03.2021.
//

import UIKit

final class CommentsCollectionViewDelegate: NSObject {
    var selectCellAtIndexCompletion: ((Int) -> Void)?
    var didEndDisplayingCellCompletion: ((UICollectionViewCell, Int) -> Void)?
}

// MARK: - UICollectionViewDelegate

extension CommentsCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCellAtIndexCompletion?(indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        didEndDisplayingCellCompletion?(cell, indexPath.row)
    }
}
