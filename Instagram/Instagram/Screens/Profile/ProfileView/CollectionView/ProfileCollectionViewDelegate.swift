//
//  ProfileCollectionViewDelegate.swift
//  Instagram
//
//  Created by Admin on 16.03.2021.
//

import UIKit

final class ProfileCollectionViewDelegate: NSObject {
    var selectCellAtIndexCompletion: ((Int) -> Void)?
    var willDisplayHeaderViewCompletion: ((ProfileHeaderView) -> Void)?
}

// MARK: - UICollectionViewDelegate

extension ProfileCollectionViewDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCellAtIndexCompletion?(indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        guard let headerView = view as? ProfileHeaderView else { return }
        
        willDisplayHeaderViewCompletion?(headerView)
    }
}
