//
//  ProfileView.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

final class ProfileView: UIView {
    // MARK: Properties
    
    private var user: User?
    
    private lazy var collectionViewGridLayout = ProfileView.createGridLayout()
    private lazy var collectionViewListLayout = ProfileView.createListLayout()
    
    // MARK: Constants
    
    private enum Metrics {
        static let estimatedHeight: CGFloat = 44
        static let gridCellSpace: CGFloat = 1.2
    }
    
    private enum Constants {
        static let columnsCount = 3
    }
    
    // MARK: Subviews
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension ProfileView {
    func setUser(_ user: User) {
        self.user = user
        
        collectionView.reloadData()
    }
}

// MARK: - Private Methods

private extension ProfileView {

}

// MARK: - Appearance

private extension ProfileView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupCollectionViewAppearance()
    }
    
    func setupCollectionViewAppearance() {
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            ProfileHeaderCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfileHeaderCollectionViewCell.reuseIdentifier)
        collectionView.register(
            ProfileCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileCollectionReusableView.reuseIdentifier)
    }
}

// MARK: - Layout

private extension ProfileView {
    func setupLayout() {
        setupSubviews()
        
        setupCollectionViewLayout()
        setupCollectionViewGridLayout()
    }
    
    func setupSubviews() {
        addSubview(collectionView)
    }
    
    func setupCollectionViewLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func setupCollectionViewGridLayout() {
        collectionView.collectionViewLayout = collectionViewGridLayout
    }
    
    func setupCollectionViewListLayout() {
        collectionView.collectionViewLayout = collectionViewListLayout
    }
}

// MARK: - Layout Helpers

private extension ProfileView {
    static func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1 / CGFloat(Constants.columnsCount)))
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemLayoutSize,
            subitem: item,
            count: Constants.columnsCount)
        
        group.interItemSpacing = .fixed(Metrics.gridCellSpace)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    static func createListLayout() -> UICollectionViewCompositionalLayout {
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Metrics.estimatedHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemLayoutSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Metrics.estimatedHeight))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        return sectionHeader
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 26
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileHeaderCollectionViewCell.reuseIdentifier,
            for: indexPath)
        
        cell.backgroundColor = .blue
        
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileCollectionReusableView.reuseIdentifier,
            for: indexPath) as? ProfileCollectionReusableView
        else {
            return UICollectionReusableView()
        }
        
        if let user = user {
            header.setUser(user)
        }
        
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileView: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileView: UICollectionViewDelegateFlowLayout {

}
