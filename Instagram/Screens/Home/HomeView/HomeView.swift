//
//  HomeView.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import UIKit

protocol HomeViewProtocol: UIView {
    func appendFirstUserPost(_ userPost: UserPost)
    func appendUsersPosts(_ usersPosts: [UserPost])
    func removeAllUserPosts()
    
    func insertFirstRow()
    func insertNewRows(count: Int)
    func reloadData()
    func endRefreshing()
    
    func showLikeButton(at index: Int)
    func showUnlikeButton(at index: Int)
    func showNotBookmarkButton(at index: Int)
    func showBookmarkButton(at index: Int)
}

protocol HomeViewOutputProtocol: AnyObject {
    func didPullToRefresh()
    func didRequestPosts()
    
    func didSelectUser(_ user: User)
    func didTapLikeButton(at index: Int, userPost: UserPost)
    func didTapUnlikeButton(at index: Int, userPost: UserPost)
    func didTapCommentButton(userPost: UserPost)
    func didTapAddToBookmarksButton(at index: Int, userPost: UserPost)
    func didTapRemoveFromBookmarksButton(at index: Int, userPost: UserPost)
}

final class HomeView: UIView {
    // MARK: Properties
    
    weak var output: HomeViewOutputProtocol?
    
    private let collectionViewDataSource = HomeCollectionViewDataSource()
    private let collectionViewDelegate = HomeCollectionViewDelegate()
    
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

extension HomeView: HomeViewProtocol {
    func appendFirstUserPost(_ userPost: UserPost) {
        collectionViewDataSource.appendFirstUserPost(userPost)
    }
    
    func appendUsersPosts(_ usersPosts: [UserPost]) {
        collectionViewDataSource.appendUsersPosts(usersPosts)
    }
    
    func removeAllUserPosts() {
        collectionViewDataSource.removeAllUsersPosts()
    }
    
    func insertFirstRow() {
        if 1 < collectionViewDataSource.usersPostsCount {
            let lastItemIndexPath = IndexPath(row: 0, section: 0)
            
            collectionView.insertItems(at: [lastItemIndexPath])
        } else {
            collectionView.reloadData()
        }
    }
    
    func insertNewRows(count: Int) {
        let itemsCount = collectionViewDataSource.usersPostsCount - count
        
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
    
    func showLikeButton(at index: Int) {
        let post = postForItem(at: index)
        
        post?.isLiked = false
    }
    
    func showUnlikeButton(at index: Int) {
        let post = postForItem(at: index)
        
        post?.isLiked = true
    }
    
    func showNotBookmarkButton(at index: Int) {
        let post = postForItem(at: index)
        
        post?.isBookmarked = false
    }
    
    func showBookmarkButton(at index: Int) {
        let post = postForItem(at: index)
        
        post?.isBookmarked = true
    }
}

// MARK: - Private Methods

private extension HomeView {
    func postForItem(at index: Int) -> PostCell? {
        let indexPath = IndexPath(row: index, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? PostCell
        
        return cell
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
        collectionView.isPrefetchingEnabled = false
        
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
        
        setupCollectionViewDataSource()
        setupCollectionViewDelegate()
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc func didPullToRefresh() {
        output?.didPullToRefresh()
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

// MARK: - CollectionViewDataSource

private extension HomeView {
    func setupCollectionViewDataSource() {
        collectionView.dataSource = collectionViewDataSource
        
        collectionViewDataSource.lastCellPresentedCompletion = { [weak self] in
            self?.output?.didRequestPosts()
        }
    }
}

// MARK: - CollectionViewDelegate

private extension HomeView {
    func setupCollectionViewDelegate() {
        collectionView.delegate = collectionViewDelegate
        
        collectionViewDelegate.willDisplayCellAtIndexCompletion = { [weak self] cell, _  in
            cell.delegate = self
        }
    }
}

// MARK: - PostCellDelegate

extension HomeView: PostCellDelegate {
    func postCellDidTapProfileImageButton(_ postCell: PostCell) {
        guard
            let indexPath = collectionView.indexPath(for: postCell),
            let user = collectionViewDataSource.getUserPost(at: indexPath.row)?.user
        else {
            return
        }
        
        output?.didSelectUser(user)
    }
    
    func postCellDidTapOptionsButton(_ postCell: PostCell) {
        
    }
    
    func postCellDidTapLikeButton(_ postCell: PostCell) {
        guard
            let indexPath = collectionView.indexPath(for: postCell),
            let userPost = collectionViewDataSource.getUserPost(at: indexPath.row)
        else {
            return
        }
        
        output?.didTapLikeButton(at: indexPath.row, userPost: userPost)
    }
    
    func postCellDidTapUnlikeButton(_ postCell: PostCell) {
        guard
            let indexPath = collectionView.indexPath(for: postCell),
            let userPost = collectionViewDataSource.getUserPost(at: indexPath.row)
        else {
            return
        }
        
        output?.didTapUnlikeButton(at: indexPath.row, userPost: userPost)
    }
    
    func postCellDidTapCommentButton(_ postCell: PostCell) {
        guard
            let indexPath = collectionView.indexPath(for: postCell),
            let userPost = collectionViewDataSource.getUserPost(at: indexPath.row)
        else {
            return
        }
        
        output?.didTapCommentButton(userPost: userPost)
    }
    
    func postCellDidTapSendButton(_ postCell: PostCell) {
        
    }
    
    func postCellDidTapBookmarkButton(_ postCell: PostCell) {
        guard
            let indexPath = collectionView.indexPath(for: postCell),
            let userPost = collectionViewDataSource.getUserPost(at: indexPath.row)
        else {
            return
        }
        
        output?.didTapAddToBookmarksButton(at: indexPath.row, userPost: userPost)
    }
    
    func postCellDidTapNotBookmarkButton(_ postCell: PostCell) {
        guard
            let indexPath = collectionView.indexPath(for: postCell),
            let userPost = collectionViewDataSource.getUserPost(at: indexPath.row)
        else {
            return
        }
        
        output?.didTapRemoveFromBookmarksButton(at: indexPath.row, userPost: userPost)
    }
}
