//
//  CommentsView.swift
//  Instagram
//
//  Created by Admin on 26.02.2021.
//

import UIKit

final class CommentsView: UIView {
    // MARK: Properties
    
    private var collectionViewHeightMinInitialized = false
    private var collectionViewHeightMin: CGFloat = 0
    private var keyboardHeight: CGFloat = 0
    
    private var containerViewBottomConstraint: NSLayoutConstraint?
    private var containerViewHeightConstraint: NSLayoutConstraint?
    
    private var keyboardAppearanceListener: KeyboardAppearanceListener?
    
    // MARK: Constants
    
    private enum Metrics {
        static let separatorViewWidth: CGFloat = 1
        
        static let commentTextViewVerticalSpace: CGFloat = 8
        static let commentTextViewHorizontalSpace: CGFloat = 12
        
        static let commentTextViewTopInset: CGFloat = 4
    }
    
    private enum Constants {
        static let keyboardAnimationDuration: TimeInterval = 0.2
    }
    
    // MARK: Subviews
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private let containerView = UIView()
    private let separatorView = UIView()
    private let commentTextView = PlaceholderTextView()
    private let sendButton = UIButton(type: .system)
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
        
        keyboardAppearanceListener = KeyboardAppearanceListener(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Appearance

private extension CommentsView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupCollectionViewAppearance()
        setupSeparatorViewAppearance()
        setupCommentTextViewAppearance()
        setupSendButtonAppearance()
    }
    
    func setupCollectionViewAppearance() {
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.reuseIdentifier)
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = .systemGray5
    }
    
    func setupCommentTextViewAppearance() {
        commentTextView.placeholderText = "Enter commentary..."
        commentTextView.isScrollEnabled = false
        
        commentTextView.delegate = self
    }
    
    func setupSendButtonAppearance() {
        sendButton.setTitle("Send", for: .normal)
    }
}

// MARK: - Layout

private extension CommentsView {
    func setupLayout() {
        setupSubviews()
        
        setupCollectionViewLayout()
        setupContainerViewLayout()
        setupSeparatorViewLayout()
        setupCommentTextViewLayout()
        setupSendButtonLayout()
    }
    
    func setupSubviews() {
        addSubview(collectionView)
        addSubview(containerView)
        
        containerView.addSubview(separatorView)
        containerView.addSubview(commentTextView)
        containerView.addSubview(sendButton)
    }
    
    func setupCollectionViewLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
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
    
    func setupContainerViewLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
        
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        containerViewBottomConstraint?.isActive = true
    }
    
    func updateContainerViewHeightLayout() {
        let safeAreaHeight = safeAreaLayoutGuide.layoutFrame.height
        let commentTextViewHeightMax = safeAreaHeight - (collectionViewHeightMin + keyboardHeight
                                                                                 + Metrics.commentTextViewTopInset)
        let metricsSpace = Metrics.commentTextViewVerticalSpace * 2 + Metrics.separatorViewWidth
        let containerViewHeight = commentTextView.contentSize.height + metricsSpace
        
        if commentTextViewHeightMax <= containerViewHeight {
            if containerViewHeightConstraint == nil {
                containerViewHeightConstraint = containerView.heightAnchor.constraint(
                    equalToConstant: commentTextViewHeightMax)
            }
            
            containerViewHeightConstraint?.isActive = true
            commentTextView.isScrollEnabled = true
        } else {
            containerViewHeightConstraint?.isActive = false
            commentTextView.isScrollEnabled = false
        }
        
        commentTextView.invalidateIntrinsicContentSize()
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: containerView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Metrics.separatorViewWidth),
        ])
    }
    
    func setupCommentTextViewLayout() {
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentTextView.topAnchor.constraint(
                equalTo: separatorView.bottomAnchor,
                constant: Metrics.commentTextViewVerticalSpace),
            commentTextView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -Metrics.commentTextViewVerticalSpace),
            commentTextView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Metrics.commentTextViewHorizontalSpace),
        ])
    }
    
    func setupSendButtonLayout() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            sendButton.bottomAnchor.constraint(equalTo: commentTextView.bottomAnchor),
            sendButton.leadingAnchor.constraint(
                equalTo: commentTextView.trailingAnchor,
                constant: Metrics.commentTextViewHorizontalSpace),
            sendButton.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Metrics.commentTextViewHorizontalSpace),
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension CommentsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CommentCell.reuseIdentifier,
            for: indexPath) as? CommentCell
        else {
            return UICollectionViewCell()
        }
        
        // TODO: FOR TEST. REMOVE
        
        //let text = "test test test test test test test test test test test test test test test test test test test test"
        let text = "test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test"
        
        cell.configure(with: text)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CommentsView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard !collectionViewHeightMinInitialized, indexPath.row == 0 else { return }
        
        collectionViewHeightMin = cell.bounds.height
        collectionViewHeightMinInitialized = true
    }
}

// MARK: - UITextViewDelegate

extension CommentsView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard !collectionViewHeightMinInitialized else { return }
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CommentCell {
            collectionViewHeightMin = cell.bounds.height
            collectionViewHeightMinInitialized = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateContainerViewHeightLayout()
    }
}

// MARK: - KeyboardAppearanceListenerDelegate

extension CommentsView: KeyboardAppearanceListenerDelegate {
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillShowWith notification: Notification
    ) {
        guard
            let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        keyboardHeight = keyboardSize.cgRectValue.height
        
        updateContainerViewLayout(bottomConstant: -keyboardHeight)
    }
    
    func keyboardAppearanceListener(
        _ listener: KeyboardAppearanceListener,
        keyboardWillHideWith notification: Notification
    ) {
        updateContainerViewLayout(bottomConstant: 0)
    }
    
    private func updateContainerViewLayout(bottomConstant: CGFloat) {
        containerViewBottomConstraint?.constant = bottomConstant
        
        UIView.animate(withDuration: Constants.keyboardAnimationDuration) {
            self.layoutIfNeeded()
        }
    }
}
