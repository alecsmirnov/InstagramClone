//
//  HomeView.swift
//  Instagram
//
//  Created by Admin on 14.01.2021.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    func homeViewDidPullToRefresh(_ homeView: HomeView)
    
    func homeView(_ homeView: HomeView, didSelectUser user: User)
    func homeView(_ homeView: HomeView, didPressLikeButton userPost: UserPost)
    func homeView(_ homeView: HomeView, didSelectUserPostComment userPost: UserPost)
}

final class HomeView: UIView {
    // MARK: Properties
    
    weak var delegate: HomeViewDelegate?
    
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
    func appendUserPost(_ userPost: UserPost) {
        userPosts.insert(userPost, at: 0)
        userPosts.sort { $0.post.timestamp > $1.post.timestamp }
    }
    
    func removeAllUserPosts() {
        userPosts.removeAll()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
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
        
        delegate?.homeView(self, didPressLikeButton: userPost)
    }
    
    func postCellDidPressCommentButton(_ postCell: PostCell) {
        guard let indexPath = collectionView.indexPath(for: postCell) else { return }
        
        let userPost = userPosts[indexPath.row]
        
        delegate?.homeView(self, didSelectUserPostComment: userPost)
    }
    
    func postCellDidPressSendButton(_ postCell: PostCell) {
        
    }
    
    func postCellDidPressBookmarkButton(_ postCell: PostCell) {
        
    }
}
