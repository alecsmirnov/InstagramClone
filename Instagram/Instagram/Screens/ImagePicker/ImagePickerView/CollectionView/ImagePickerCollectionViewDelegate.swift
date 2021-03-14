//
//  ImagePickerCollectionViewDelegate.swift
//  Instagram
//
//  Created by Admin on 14.03.2021.
//

import UIKit

final class ImagePickerCollectionViewDelegate: NSObject {
    var selectCellAtIndexCompletion: ((Int) -> Void)?
    var willDisplayCellAtIndexCompletion: ((UICollectionViewCell, Int) -> Void)?
}

// MARK: - UICollectionViewDelegate

extension ImagePickerCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCellAtIndexCompletion?(indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        willDisplayCellAtIndexCompletion?(cell, indexPath.row)
    }
}
