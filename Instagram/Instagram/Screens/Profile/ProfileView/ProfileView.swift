//
//  ProfileView.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

protocol ProfileViewDelegate: AnyObject {
    func profileViewDidRequestPosts(_ profileView: ProfileView)
    
    func profileViewDidPressFollowersButton(_ profileView: ProfileView)
    func profileViewDidPressFollowingButton(_ profileView: ProfileView)
    
    func profileViewDidPressEditButton( _ profileView: ProfileView)
    func profileViewDidPressFollowButton(_ profileView: ProfileView)
    func profileViewDidPressUnfollowButton( _ profileView: ProfileView)
    
    func profileViewDidPressGridButton(_ profileView: ProfileView)
    func profileViewDidPressBookmarkButton(_ profileView: ProfileView)
    
    func profileView(_ profileView: ProfileView, didSelectPost post: Post)
}

final class ProfileView: UIView {
    // MARK: Properties
    
    weak var delegate: ProfileViewDelegate?
    
    var editFollowButtonState = EditFollowButtonState.none
    
    private var user: User?
    private var userStats: UserStats?
    private var posts = [Post]()
    
    // MARK: Constants
    
    enum EditFollowButtonState {
        case edit
        case follow
        case unfollow
        case none
    }
    
    private enum Metrics {
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
    }
    
    func setUserStats(_ userStats: UserStats) {
        self.userStats = userStats
    }
    
    func appendFirstPost(_ post: Post) {
        posts.insert(post, at: 0)
    }
    
    func appendLastPost(_ post: Post) {
        posts.append(post)
    }
    
    func removeAllPosts() {
        posts.removeAll()
    }
    
    func reloadData() {
        UIView.transition(with: collectionView, duration: 0.15, options: [.transitionCrossDissolve]) {
            self.collectionView.reloadData()
        }
    }
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
            ProfileHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderView.reuseIdentifier)
        collectionView.register(ProfilePostCell.self, forCellWithReuseIdentifier: ProfilePostCell.reuseIdentifier)
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
        
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfilePostCell.reuseIdentifier,
            for: indexPath) as? ProfilePostCell
        else {
            return UICollectionViewCell()
        }
        
        if indexPath.row == posts.count - 1 {
            delegate?.profileViewDidRequestPosts(self)
        }
        
        cell.configure(with: posts[indexPath.row])
        
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileHeaderView.reuseIdentifier,
            for: indexPath) as? ProfileHeaderView
        else {
            return UICollectionReusableView()
        }
        
        header.delegate = self
        
        if let user = user {
            header.setUser(user)
        }
        
        if let userStats = userStats {
            header.setUserStats(userStats)
        }
        
        switch editFollowButtonState {
        case .edit:
            header.setupEditFollowButtonEditStyle()
        case .follow:
            header.setupEditFollowButtonFollowStyle()
        case .unfollow:
            header.setupEditFollowButtonUnfollowStyle()
        case .none:
            break
        }
        
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        delegate?.profileView(self, didSelectPost: post)
    }
}

// MARK: - ProfileHeaderViewDelegate

extension ProfileView: ProfileHeaderViewDelegate {
    func profileHeaderViewDidPressFollowersButton(_ profileView: ProfileHeaderView) {
        delegate?.profileViewDidPressFollowersButton(self)
    }
    
    func profileHeaderViewDidPressFollowingButton(_ profileView: ProfileHeaderView) {
        delegate?.profileViewDidPressFollowingButton(self)
    }
    
    func profileHeaderViewDidPressEditFollowButton(_ profileView: ProfileHeaderView) {
        switch editFollowButtonState {
        case .edit:
            delegate?.profileViewDidPressEditButton(self)
        case .follow:
            delegate?.profileViewDidPressFollowButton(self)
        case .unfollow:
            delegate?.profileViewDidPressUnfollowButton(self)
        case .none:
            break
        }
    }
    
    func profileHeaderViewDidPressGridButton(_ view: ProfileHeaderView) {
        delegate?.profileViewDidPressGridButton(self)
    }
    
    func profileHeaderViewDidPressBookmarkButton(_ view: ProfileHeaderView) {
        delegate?.profileViewDidPressBookmarkButton(self)
    }
}
