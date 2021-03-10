//
//  FollowersFollowingView.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

import UIKit

protocol FollowersFollowingViewDelegate: AnyObject {
    func followersFollowingViewDidPullToRefresh(_ followersFollowingView: FollowersFollowingView)
    func followersFollowingViewDidRequestUsers(_ followersFollowingView: FollowersFollowingView)
    
    func followersFollowingView(_ followersFollowingView: FollowersFollowingView, didSelectUser user: User)
    func followersFollowingView(
        _ followersFollowingView: FollowersFollowingView,
        didPressFollowButtonAt index: Int,
        user: User)
    func followersFollowingView(
        _ followersFollowingView: FollowersFollowingView,
        didPressUnfollowButtonAt index: Int,
        user: User)
    func followersFollowingView(
        _ followersFollowingView: FollowersFollowingView,
        didPressRemoveButtonAt index: Int,
        user: User)
}

final class FollowersFollowingView: UIView {
    // MARK: Properties
    
    weak var delegate: FollowersFollowingViewDelegate?
    
    private var users = [User]()
    private var buttonStates = [FollowUnfollowRemoveButtonState]()
    
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

extension FollowersFollowingView {
    func appendUser(_ user: User, buttonState: FollowUnfollowRemoveButtonState) {
        users.append(user)
        buttonStates.append(buttonState)
    }
    
    func changeButtonState(_ buttonState: FollowUnfollowRemoveButtonState, at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? FollowersFollowingCell
        
        cell?.changeButtonState(buttonState)
    }
    
    func removeAllUsers() {
        users.removeAll()
        buttonStates.removeAll()
    }
    
    func insertNewRow() {
        if 1 < users.count {
            let lastItemIndexPath = IndexPath(row: users.count - 1, section: 0)
            
            collectionView.insertItems(at: [lastItemIndexPath])
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

// MARK: - Appearance

private extension FollowersFollowingView {
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
            FollowersFollowingCell.self,
            forCellWithReuseIdentifier: FollowersFollowingCell.reuseIdentifier)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc func didPullToRefresh() {
        delegate?.followersFollowingViewDidPullToRefresh(self)
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

// MARK: - UICollectionViewDataSource

extension FollowersFollowingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FollowersFollowingCell.reuseIdentifier,
            for: indexPath) as? FollowersFollowingCell
        else {
            return UICollectionViewCell()
        }
        
        if indexPath.row == users.count - 1 {
            delegate?.followersFollowingViewDidRequestUsers(self)
        }
        
        cell.delegate = self
        cell.configure(with: users[indexPath.row], buttonState: buttonStates[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FollowersFollowingView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        delegate?.followersFollowingView(self, didSelectUser: user)
    }
}

// MARK: - FollowersFollowingCellDelegate

extension FollowersFollowingView: FollowersFollowingCellDelegate {
    func followersFollowingCellDidPressFollowButton(_ followersFollowingCell: FollowersFollowingCell) {
        guard let indexPath = collectionView.indexPath(for: followersFollowingCell) else { return }
        
        let user = users[indexPath.row]
        
        delegate?.followersFollowingView(self, didPressFollowButtonAt: indexPath.row, user: user)
    }
    
    func followersFollowingCellDidPressUnfollowButton(_ followersFollowingCell: FollowersFollowingCell) {
        guard let indexPath = collectionView.indexPath(for: followersFollowingCell) else { return }
        
        let user = users[indexPath.row]
        
        delegate?.followersFollowingView(self, didPressUnfollowButtonAt: indexPath.row, user: user)
    }
    
    func followersFollowingCellDidPressRemoveButton(_ followersFollowingCell: FollowersFollowingCell) {
        guard let indexPath = collectionView.indexPath(for: followersFollowingCell) else { return }
        
        let user = users[indexPath.row]
        
        delegate?.followersFollowingView(self, didPressRemoveButtonAt: indexPath.row, user: user)
    }
}
