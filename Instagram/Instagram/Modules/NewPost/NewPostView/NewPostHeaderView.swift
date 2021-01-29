//
//  NewPostHeaderView.swift
//  Instagram
//
//  Created by Admin on 29.01.2021.
//

import UIKit

final class NewPostHeaderView: UICollectionReusableView {
    // MARK: Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
