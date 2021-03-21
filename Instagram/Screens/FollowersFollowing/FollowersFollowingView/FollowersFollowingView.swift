//
//  FollowersFollowingView.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

import UIKit

protocol FollowersFollowingViewProtocol: UIView {
    func setupFollowersAppearance()
    func setupFollowingAppearance()
    func setupUsersAppearance()
    
    func appendUsers(_ users: [User])
    func removeAllUsers()
    
    func setupFollowButton(at index: Int)
    func setupUnfollowButton(at index: Int)
    func setupRemoveButton(at index: Int)
    func setupNoButton(at index: Int)
    
    func insertNewRows(count: Int)
    func reloadData()
    func endRefreshing()
}

protocol FollowersFollowingViewOutputProtocol: AnyObject {
    func didPullToRefresh()
    func didRequestUsers()
    
    func didSelectUser(_ user: User)
    func didTapFollowButton(at index: Int, for user: User)
    func didTapUnfollowButton(at index: Int, for user: User)
    func didTapRemoveButton(at index: Int, for user: User)
}

final class FollowersFollowingView: UIView {
    // MARK: Properties
    
    weak var output: FollowersFollowingViewOutputProtocol?
    
    private let collectionViewDataSource = FollowersFollowingCollectionViewDataSource()
    private let collectionViewDelegate = FollowersFollowingCollectionViewDelegate()
    
    // MARK: Subviews
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Interface

extension FollowersFollowingView: FollowersFollowingViewProtocol {
    func setupFollowersAppearance() {
        collectionViewDataSource.usersType = .followers
    }
    
    func setupFollowingAppearance() {
        collectionViewDataSource.usersType = .following
    }
    
    func setupUsersAppearance() {
        collectionViewDataSource.usersType = .users
    }
    
    func appendUsers(_ users: [User]) {
        collectionViewDataSource.appendUsers(users)
    }
    
    func setupFollowButton(at index: Int) {
        let cell = getCell(at: index)
        
        cell?.followUnfollowRemoveButtonState = .follow
    }
    
    func setupUnfollowButton(at index: Int) {
        let cell = getCell(at: index)
        
        cell?.followUnfollowRemoveButtonState = .unfollow
    }
    
    func setupRemoveButton(at index: Int) {
        let cell = getCell(at: index)
        
        cell?.followUnfollowRemoveButtonState = .remove
    }
    
    func setupNoButton(at index: Int) {
        let cell = getCell(at: index)
        
        cell?.followUnfollowRemoveButtonState = .none
    }
    
    func removeAllUsers() {
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
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
}

// MARK: - Private Methods

private extension FollowersFollowingView {
    func getCell(at index: Int) -> UserFollowerCell? {
        let indexPath = IndexPath(row: index, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? UserFollowerCell
        
        return cell
    }
}

// MARK: - Appearance

private extension FollowersFollowingView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupCollectionViewAppearance()
    }
    
    func setupCollectionViewAppearance() {
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        
        collectionView.register(
            UserFollowerCell.self,
            forCellWithReuseIdentifier: UserFollowerCell.reuseIdentifier)
        
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

private extension FollowersFollowingView {
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

extension FollowersFollowingView {
    func setupCollectionViewDataSource() {
        collectionView.dataSource = collectionViewDataSource
        
        collectionViewDataSource.lastCellPresentedCompletion = { [weak self] in
            self?.output?.didRequestUsers()
        }
    }
}

// MARK: - CollectionViewDelegate

extension FollowersFollowingView {
    func setupCollectionViewDelegate() {
        collectionView.delegate = collectionViewDelegate
        
        collectionViewDelegate.selectCellAtIndexCompletion = { [weak self] index in
            guard let user = self?.collectionViewDataSource.getUser(at: index) else { return }
            
            self?.output?.didSelectUser(user)
        }
        
        collectionViewDelegate.willDisplayCellAtIndexCompletion = { [weak self] cell, _ in
            cell.delegate = self
        }
    }
}

// MARK: - FollowersFollowingCellDelegate

extension FollowersFollowingView: FollowersFollowingCellDelegate {
    func followersFollowingCellDidTapFollowButton(_ followersFollowingCell: UserFollowerCell) {
        guard
            let index = collectionView.indexPath(for: followersFollowingCell)?.row,
            let user = collectionViewDataSource.getUser(at: index)
        else {
            return
        }
        
        output?.didTapFollowButton(at: index, for: user)
    }
    
    func followersFollowingCellDidTapUnfollowButton(_ followersFollowingCell: UserFollowerCell) {
        guard
            let index = collectionView.indexPath(for: followersFollowingCell)?.row,
            let user = collectionViewDataSource.getUser(at: index)
        else {
            return
        }
        
        output?.didTapUnfollowButton(at: index, for: user)
    }
    
    func followersFollowingCellDidTapRemoveButton(_ followersFollowingCell: UserFollowerCell) {
        guard
            let index = collectionView.indexPath(for: followersFollowingCell)?.row,
            let user = collectionViewDataSource.getUser(at: index)
        else {
            return
        }
        
        output?.didTapRemoveButton(at: index, for: user)
    }
}
