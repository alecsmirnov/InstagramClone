//
//  HomeView.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    func homeViewDidPullToRefresh(_ homeView: HomeView)
    func homeViewDidRequestPosts(_ homeView: HomeView)
    
    func homeView(_ homeView: HomeView, didSelectUser user: User)
    func homeView(_ homeView: HomeView, didPressLikeButtonAt index: Int, userPost: UserPost)
    func homeView(_ homeView: HomeView, didPressUnlikeButtonAt index: Int, userPost: UserPost)
    func homeView(_ homeView: HomeView, didPressCommentButton userPost: UserPost)
}

final class HomeView: UIView {
    // MARK: Properties
    
    weak var delegate: HomeViewDelegate?
    
    private var lastRequestedPostIndex: Int?
    private var userPosts = [UserPost]()
    
    // MARK: Subviews
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension HomeView {    
    func appendFirstUserPost(_ userPost: UserPost) {
        userPosts.insert(userPost, at: 0)
    }
    
    func appendLastUserPost(_ userPost: UserPost) {
        userPosts.append(userPost)
    }
    
    func removeAllUserPosts() {
        lastRequestedPostIndex = nil
        
        userPosts.removeAll()
    }
    
    func insertFirstRow() {
        insertRow(at: 0)
    }
    
    func insertLastRow() {
        insertRow(at: userPosts.count - 1)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func reloadRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func showLikeButton(at index: Int) {
        let userPost = userPosts[index]
        
        var post = userPost.post
        post.isLiked = false
        
        userPosts[index] = UserPost(user: userPost.user, post: post)
        
        reloadRow(at: index)
    }
    
    func showUnlikeButton(at index: Int) {
        let userPost = userPosts[index]
        
        var post = userPost.post
        post.isLiked = true
        
        userPosts[index] = UserPost(user: userPost.user, post: post)
        
        reloadRow(at: index)
    }
    
    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
}

// MARK: - Private Methods

private extension HomeView {
    func insertRow(at index: Int) {
        if 1 < userPosts.count {
            let lastItemIndexPath = IndexPath(row: index, section: 0)
            
            collectionView.insertItems(at: [lastItemIndexPath])
        } else {
            collectionView.reloadData()
        }
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

// MARK: - Actions

private extension HomeView {
    func setupActions() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc func didPullToRefresh() {
        delegate?.homeViewDidPullToRefresh(self)
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
        
        // Check for multiple function calls (show hidden cells) and
        // and the size of dynamic cell, which the collectionView defines as 44 (strange bug...)
        
        if indexPath.row == userPosts.count - 1 && (lastRequestedPostIndex ?? -1) < indexPath.row {
            lastRequestedPostIndex = indexPath.row

            delegate?.homeViewDidRequestPosts(self)
        }
        
        cell.delegate = self
        cell.configure(with: userPosts[indexPath.row])
        
        return cell
    }
}

// MARK: - PostCellDelegate

extension HomeView: PostCellDelegate {
    func postCellDidPressProfileImageButton(_ postCell: PostCell) {
        guard let indexPath = collectionView.indexPath(for: postCell) else { return }
        
        let user = userPosts[indexPath.row].user
        
        delegate?.homeView(self, didSelectUser: user)
    }
    
    func postCellDidPressOptionsButton(_ postCell: PostCell) {
        
    }
    
    func postCellDidPressLikeButton(_ postCell: PostCell) {
        guard let indexPath = collectionView.indexPath(for: postCell) else { return }
        
        let userPost = userPosts[indexPath.row]
        
        delegate?.homeView(self, didPressLikeButtonAt: indexPath.row, userPost: userPost)
    }
    
    func postCellDidPressUnlikeButton(_ postCell: PostCell) {
        guard let indexPath = collectionView.indexPath(for: postCell) else { return }
        
        let userPost = userPosts[indexPath.row]
        
        delegate?.homeView(self, didPressUnlikeButtonAt: indexPath.row, userPost: userPost)
    }
    
    func postCellDidPressCommentButton(_ postCell: PostCell) {
        guard let indexPath = collectionView.indexPath(for: postCell) else { return }
        
        let userPost = userPosts[indexPath.row]
        
        delegate?.homeView(self, didPressCommentButton: userPost)
    }
    
    func postCellDidPressSendButton(_ postCell: PostCell) {
        
    }
    
    func postCellDidPressBookmarkButton(_ postCell: PostCell) {
        
    }
}
