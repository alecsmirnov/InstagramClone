//
//  HomeView.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import UIKit

final class HomeView: UIView {
    // MARK: Properties
    
    private var userPosts = [UserPost]()
    
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

extension HomeView {    
    func appendUserPost(_ userPost: UserPost) {
        userPosts.append(userPost)
        
        collectionView.reloadData()
    }
}

// MARK: - Appearance

private extension HomeView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupCollectionViewAppearance()
    }
    
    func setupCollectionViewAppearance() {
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        
        collectionView.dataSource = self
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
    }
}

// MARK: - Layout

private extension HomeView {
    func setupLayout() {
        setupSubviews()
        
        setupCollectionViewLayout()
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
        
        setupCollectionViewListLayout()
    }
    
    func setupCollectionViewListLayout() {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        listConfiguration.showsSeparators = false
        
        let collectionViewLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)

        collectionView.collectionViewLayout = collectionViewLayout
    }
}

// MARK: - UICollectionViewDataSource

extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCell.reuseIdentifier,
            for: indexPath) as? PostCell
        else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        cell.configure(with: userPosts[indexPath.row])
        
        return cell
    }
}

// MARK: - PostCellDelegate

extension HomeView: PostCellDelegate {
    func postCellRequestUpdate(_ postCell: PostCell) {
        let contentOffset = collectionView.contentOffset
        
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.setContentOffset(contentOffset, animated: false)
    }
}
