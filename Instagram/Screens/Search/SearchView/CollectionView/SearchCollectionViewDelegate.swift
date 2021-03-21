//
//  SearchCollectionViewDelegate.swift
//  Instagram
//
//  Created by Admin on 15.03.2021.
//

import UIKit

final class SearchCollectionViewDelegate: NSObject {
    var selectCellAtIndexCompletion: ((Int) -> Void)?
}

// MARK: - UICollectionViewDelegate

extension SearchCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCellAtIndexCompletion?(indexPath.row)
    }
}
