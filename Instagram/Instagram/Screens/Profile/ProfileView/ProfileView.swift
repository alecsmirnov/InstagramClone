//
//  ProfileView.swift
//  Instagram
//
//  Created by Admin on 21.01.2021.
//

import UIKit

protocol ProfileViewProtocol: UIView {
    func setUser(_ user: User)
    func setUserStats(_ userStats: UserStats)
    
    func appendFirstPost(_ post: Post)
    func appendPosts(_ posts: [Post])
    func removeAllPosts()
    
    func insertNewFirstItem()
    func insertNewLastItems(count: Int)
    func reloadData()
    
    func showEditButton()
    func showFollowButton()
    func showUnfollowButton()
}

protocol ProfileViewOutputProtocol: AnyObject {
    func didRequestPosts()
    
    func didTapFollowersButton()
    func didTapFollowingButton()
    func didTapEditButton()
    func didTapFollowButton()
    func didTapUnfollowButton()
    func didTapGridButton()
    func didTapBookmarkButton()
    
    func didSelectPost(_ post: Post)
}

final class ProfileView: UIView {
    // MARK: Properties
    
    weak var output: ProfileViewOutputProtocol?
    
    private let collectionViewDataSource = ProfileCollectionViewDataSource()
    private let collectionViewDelegate = ProfileCollectionViewDelegate()
    
    // MARK: Constants
    
    private enum Metrics {
        static let gridCellSpace: CGFloat = 1.2
    }
    
    private enum Constants {
        static let columnsCount = 3
        
        static let reloadDataAnimationDuration: TimeInterval = 0.15
    }
    
    // MARK: Subviews
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Interface

extension ProfileView: ProfileViewProtocol {
    func setUser(_ user: User) {
        guard let headerView = getHeaderView() else {
            collectionViewDataSource.setInitialUser(user)
            
            return
        }
        
        headerView.setUser(user)
    }
    
    func setUserStats(_ userStats: UserStats) {
        guard let headerView = getHeaderView() else {
            collectionViewDataSource.setInitialUserStats(userStats)
            
            return
        }
        
        headerView.setUserStats(userStats)
    }
    
    func appendFirstPost(_ post: Post) {
        collectionViewDataSource.insertFirstPost(post)
    }
    
    func appendPosts(_ posts: [Post]) {
        collectionViewDataSource.appendPosts(posts)
    }
    
    func removeAllPosts() {
        collectionViewDataSource.removeAllPosts()
    }
    
    func insertNewFirstItem() {
        if 1 < collectionViewDataSource.postsCount {
            collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
        } else {
            collectionView.reloadData()
        }
    }
    
    func insertNewLastItems(count: Int) {
        let itemsCount = collectionViewDataSource.postsCount - count
        
        if 1 < itemsCount {
            let lastRowIndex = itemsCount
            let indexPaths = (0..<count).map { IndexPath(row: $0 + lastRowIndex, section: 0) }
            
            collectionView.insertItems(at: indexPaths)
        } else {
            collectionView.reloadData()
        }
    }
    
    func reloadData() {
        UIView.transition(
            with: collectionView,
            duration: Constants.reloadDataAnimationDuration,
            options: [.transitionCrossDissolve]) {
            self.collectionView.reloadData()
        }
    }
    
    func showEditButton() {
        guard let headerView = getHeaderView() else { return }
        
        headerView.editFollowButtonState = .edit
    }

    func showFollowButton() {
        guard let headerView = getHeaderView() else { return }
        
        headerView.editFollowButtonState = .follow
    }

    func showUnfollowButton() {
        guard let headerView = getHeaderView() else { return }
        
        headerView.editFollowButtonState = .unfollow
    }
}

// MARK: - Private Methods

private extension ProfileView {
    func getHeaderView() -> ProfileHeaderView? {
        let headerView = collectionView.visibleSupplementaryViews(
            ofKind: UICollectionView.elementKindSectionHeader).first as? ProfileHeaderView
        
        return headerView
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
        
        collectionView.register(
            ProfileHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderView.reuseIdentifier)
        collectionView.register(DownloadImageCell.self, forCellWithReuseIdentifier: DownloadImageCell.reuseIdentifier)
        
        setupCollectionViewDataSource()
        setupCollectionViewDelegate()
    }
}

// MARK: - Layout

private extension ProfileView {
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
        
        collectionView.collectionViewLayout = ProfileView.createCollectionViewCompositionalLayout()
    }
    
    static func createCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
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
        
        // Dynamic header causes a problem with the calculation of cell sizes,
        // which causes multiple calls to the cellForItemAt method. I don't know how to fix that :(
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - CollectionViewDataSource

private extension ProfileView {
    func setupCollectionViewDataSource() {
        collectionView.dataSource = collectionViewDataSource
        
        collectionViewDataSource.lastCellPresentedCompletion = { [weak self] in
            self?.output?.didRequestPosts()
        }
    }
}

// MARK: - CollectionViewDelegate

private extension ProfileView {
    func setupCollectionViewDelegate() {
        collectionView.delegate = collectionViewDelegate
        
        collectionViewDelegate.selectCellAtIndexCompletion = { [weak self] index in
            guard let post = self?.collectionViewDataSource.getPost(at: index) else { return }
            
            self?.output?.didSelectPost(post)
        }
        
        collectionViewDelegate.willDisplayHeaderViewCompletion = { [weak self] headerView in
            headerView.output = self
        }
    }
}

// MARK: - ProfileHeaderView Output

extension ProfileView: ProfileHeaderViewOutputProtocol {
    func didTapFollowersButton() {
        output?.didTapFollowersButton()
    }
    
    func didTapFollowingButton() {
        output?.didTapFollowingButton()
    }
    
    func didTapEditButton() {
        output?.didTapEditButton()
    }
    
    func didTapFollowButton() {
        output?.didTapFollowButton()
    }
    
    func didTapUnfollowButton() {
        output?.didTapUnfollowButton()
    }
    
    func didTapGridButton() {
        output?.didTapGridButton()
    }
    
    func didTapBookmarkButton() {
        output?.didTapBookmarkButton()
    }
}
