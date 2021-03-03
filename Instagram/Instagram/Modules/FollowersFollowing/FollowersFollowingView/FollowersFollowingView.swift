//
//  FollowersFollowingView.swift
//  Instagram
//
//  Created by Admin on 03.03.2021.
//

import UIKit

protocol FollowersFollowingViewDelegate: AnyObject {
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
    private var usersStates = [FollowUnfollowRemoveButtonState]()
    
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
    func appendUser(_ user: User, userState: FollowUnfollowRemoveButtonState) {
        users.append(user)
        usersStates.append(userState)
    }
    
    func updateUser(at index: Int, userState: FollowUnfollowRemoveButtonState) {
        usersStates[index] = userState
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func reloadRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
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
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.dataSource = self
        //collectionView.delegate = self
        
        collectionView.register(
            FollowersFollowingCell.self,
            forCellWithReuseIdentifier: FollowersFollowingCell.reuseIdentifier)
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
        
        cell.delegate = self
        cell.configure(with: users[indexPath.row], userState: usersStates[indexPath.row])
        
        return cell
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
