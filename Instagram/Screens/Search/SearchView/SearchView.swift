//
//  SearchView.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import UIKit

protocol SearchViewProtocol: UIView {
    func appendUsers(_ users: [User])
    func removeAllUsers()
    
    func insertNewRows(count: Int)
    func endRefreshing()
    
    func setupSearchAppearance()
    func setupNoResultAppearance()
    func setupResultAppearance()
}

protocol SearchViewOutputProtocol: AnyObject {
    func didPullToRefresh()
    func didRequestUser()
    func didSelectUser(_ user: User)
}

final class SearchView: UIView {
    // MARK: Properties
    
    weak var output: SearchViewOutputProtocol?
    
    private var lastRequestedUserIndex: Int?
    
    private let collectionViewDataSource = SearchCollectionViewDataSource()
    private let collectionViewDelegate = SearchCollectionViewDelegate()
    
    // MARK: Constants
    
    private enum Constants {
        static let collectionViewAnimationDuration: TimeInterval = 0.1
    }
    
    // MARK: Subviews
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Interface

extension SearchView: SearchViewProtocol {
    func appendUsers(_ users: [User]) {
        collectionViewDataSource.appendUsers(users)
    }
    
    func removeAllUsers() {
        lastRequestedUserIndex = nil
        
        collectionViewDataSource.removeAllUsers()
    }
    
    func insertNewRows(count: Int) {
        let itemsCount = collectionViewDataSource.usersCount - count
        
        if 1 < itemsCount {
            let lastRowIndex = itemsCount
            let indexPaths = (0..<count).map { IndexPath(row: $0 + lastRowIndex, section: 0) }
            
            collectionView.insertItems(at: indexPaths)
        } else {
            collectionView.reloadData()
        }
    }
    
    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
    
    func setupSearchAppearance() {
        collectionViewDataSource.state = .search
        
        reloadData()
    }
    
    func setupNoResultAppearance() {
        collectionViewDataSource.state = .noResult
        
        reloadData()
    }
    
    func setupResultAppearance() {
        collectionViewDataSource.state = .result
        
        reloadData()
    }
}

// MARK: - Private Methods

private extension SearchView {
    func reloadData() {
        UIView.transition(
            with: collectionView,
            duration: Constants.collectionViewAnimationDuration,
            options: [.transitionCrossDissolve]) {
            self.collectionView.reloadData()
        }
        
        collectionView.layoutIfNeeded()
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
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseIdentifier)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseIdentifier)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        setupCollectionViewDataSource()
        setupCollectionViewDelegate()
    }
    
    @objc func didPullToRefresh() {
        output?.didPullToRefresh()
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

// MARK: - CollectionViewDataSource

private extension SearchView {
    func setupCollectionViewDataSource() {
        collectionView.dataSource = collectionViewDataSource
        
        collectionViewDataSource.lastCellPresentedCompletion = { [weak self] in
            self?.output?.didRequestUser()
        }
    }
}

// MARK: - CollectionViewDelegate

private extension SearchView {
    func setupCollectionViewDelegate() {
        collectionView.delegate = collectionViewDelegate
        
        collectionViewDelegate.selectCellAtIndexCompletion = { [weak self] index in
            self?.selectCell(at: index)
        }
    }
    
    func selectCell(at index: Int) {
        guard collectionViewDataSource.state == .result else { return }
        
        if let user = collectionViewDataSource.getUser(at: index) {
            output?.didSelectUser(user)
        }
    }
}
