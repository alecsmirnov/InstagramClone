//
//  NewPostView.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

protocol NewPostViewDelegate: AnyObject {
    func newPostViewDidRequestCellMediaFile(_ newPostView: NewPostView)
    func newPostViewDidRequestOriginalMediaFile(_ newPostView: NewPostView, at index: Int)
}

final class NewPostView: UIView {
    // MARK: Properties
    
    weak var delegate: NewPostViewDelegate? {
        didSet {
            delegate?.newPostViewDidRequestCellMediaFile(self)
        }
    }
    
    private var mediaFiles = [MediaFileType]()
    private var selectedMediaFileIndex: Int?
    
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

extension NewPostView {    
    func appendCellMediaFile(_ mediaFile: MediaFileType) {
        mediaFiles.append(mediaFile)
        
        if selectedMediaFileIndex == nil {
            selectedMediaFileIndex = 0
            
            delegate?.newPostViewDidRequestOriginalMediaFile(self, at: 0)
        }
        
        collectionView.reloadData()
    }
    
    func setOriginalMediaFile(_ mediaFile: MediaFileType) {
        if let headerView = collectionView.visibleSupplementaryViews(
            ofKind: UICollectionView.elementKindSectionHeader).first as? NewPostHeaderView {
            headerView.configure(with: mediaFile)
        }
    }
    
    func getSelectedMediaFile() -> MediaFileType? {
        guard
            let headerView = collectionView.visibleSupplementaryViews(
                ofKind: UICollectionView.elementKindSectionHeader).first as? NewPostHeaderView,
            let croppedImage = headerView.getCroppedImage()
        else {
            return nil
        }
        
        return .image(croppedImage)
    }
}

// MARK: - Appearance

private extension NewPostView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupCollectionViewAppearance()
    }
    
    func setupCollectionViewAppearance() {
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MediaCell.self, forCellWithReuseIdentifier: MediaCell.reuseIdentifier)
        collectionView.register(
            NewPostHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NewPostHeaderView.reuseIdentifier)
    }
}

// MARK: - Layout

private extension NewPostView {
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
        
        collectionView.collectionViewLayout = NewPostView.createCollectionViewCompositionalLayout()
    }
}

// MARK: - Layout Helpers

private extension NewPostView {
    static func createCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1 / CGFloat(NewPostConstants.Constants.columnsCount)))
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemLayoutSize,
            subitem: item,
            count: NewPostConstants.Constants.columnsCount)
        
        group.interItemSpacing = .fixed(NewPostConstants.Metrics.gridCellSpace)
        
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: NewPostConstants.Metrics.gridCellSpace,
            leading: 0,
            bottom: 0,
            trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionViewDataSource

extension NewPostView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaFiles.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MediaCell.reuseIdentifier,
            for: indexPath) as? MediaCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: mediaFiles[indexPath.row])

        if let selectedMediaFileIndex = selectedMediaFileIndex, selectedMediaFileIndex == indexPath.row {
            cell.contentView.alpha = NewPostConstants.Constants.selectedCellAlpha
        } else {
            cell.contentView.alpha = NewPostConstants.Constants.unselectedCellAlpha
        }
        
        if indexPath.row == mediaFiles.count - 1 {
            delegate?.newPostViewDidRequestCellMediaFile(self)
        }
        
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: NewPostHeaderView.reuseIdentifier,
            for: indexPath) as? NewPostHeaderView
        else {
            return UICollectionReusableView()
        }

        return header
    }
}

// MARK: - UICollectionViewDelegate

extension NewPostView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousSelectedMediaFileIndex = selectedMediaFileIndex
        
        selectedMediaFileIndex = indexPath.row
        
        if previousSelectedMediaFileIndex != selectedMediaFileIndex {
            setOriginalMediaFile(mediaFiles[indexPath.row])
            
            delegate?.newPostViewDidRequestOriginalMediaFile(self, at: indexPath.row)
            
            if let previousSelectedMediaFileIndex = previousSelectedMediaFileIndex {
                let previousIndexPath = IndexPath(row: previousSelectedMediaFileIndex, section: 0)

                collectionView.reloadItems(at: [previousIndexPath])
                collectionView.reloadItems(at: [indexPath])
            }
            
            let topIndexPath = IndexPath(row: 0, section: 0)
            
            collectionView.scrollToItem(at: topIndexPath, at: .bottom, animated: true)
        }
    }
}
