//
//  SearchView.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import UIKit

final class SearchView: UIView {
    // MARK: Properties
    
    var state = SearchState.result
    
    private var users = [User]()
    
    // MARK: Constants
    
    enum SearchState {
        case search
        case noResult
        case result
    }
    
    private enum Constants {
        static let collectionViewAnimationDuration: TimeInterval = 0.1
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

extension SearchView {
    func appendUser(_ user: User) {
        users.append(user)
    }
    
    func removeAllUsers() {
        users.removeAll()
    }
    
    func reloadData() {
        UIView.transition(
            with: collectionView,
            duration: Constants.collectionViewAnimationDuration,
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
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
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
        switch state {
        case .search, .noResult:
            return 1
        case .result:
            return users.count
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch state {
        case .search, .noResult:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SearchCell.reuseIdentifier,
                for: indexPath) as? SearchCell
            else {
                return UICollectionViewCell()
            }
            
            if state == .search {
                cell.showSearchMessage()
            } else {
                cell.showNoResultMessage()
            }
            
            return cell
        case .result:
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
}
