//
//  SearchView.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import UIKit

final class SearchView: UIView {
    // MARK: Properties
    
    private var users = [User]()
    
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

extension SearchView {
    func appendUser(_ user: User) {
        users.append(user)
        
        reloadCollectionView()
    }
    
    func removeAllUsers() {
        users.removeAll()
        
        reloadCollectionView()
    }
}

// MARK: - Private Methods

private extension SearchView {
    func reloadCollectionView() {
        UIView.transition(
            with: collectionView,
            duration: 0.1,
            options: [.transitionCrossDissolve]) {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Appearance

private extension SearchView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupCollectionViewAppearance()
    }
    
    func setupCollectionViewAppearance() {
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        
        collectionView.dataSource = self
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseIdentifier)
    }
}

// MARK: - Layout

private extension SearchView {
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

extension SearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserCell.reuseIdentifier,
            for: indexPath) as? UserCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: users[indexPath.row])
        
        return cell
    }
}
