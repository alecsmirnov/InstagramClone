//
//  NewPostView.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

final class NewPostView: UIView {
    // MARK: Properties
    
    private var mediaFiles = [MediaFileType]()
    
    private var selectedMediaFileIndex: Int?
    
    // MARK: Constants
    
    private enum Metrics {
        static let gridCellSpace: CGFloat = 1.2
    }
    
    private enum Constants {
        static let columnsCount = 4
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

extension NewPostView {
    func setMediaFiles(_ mediaFiles: [MediaFileType]) {
        self.mediaFiles = mediaFiles
        
        if selectedMediaFileIndex == nil {
            selectedMediaFileIndex = 0
        }
    }
    
    func appendMediaFile(_ mediaFile: MediaFileType) {
        mediaFiles.append(mediaFile)
        
        if selectedMediaFileIndex == nil {
            selectedMediaFileIndex = 0
        }
        
        collectionView.reloadData()
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
        
        collectionView.register(
            MediaCell.self,
            forCellWithReuseIdentifier: MediaCell.reuseIdentifier)
        collectionView.register(
            MediaCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MediaCell.reuseIdentifier)
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
            heightDimension: .fractionalWidth(1 / CGFloat(Constants.columnsCount)))
        
        let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemLayoutSize,
            subitem: item,
            count: Constants.columnsCount)
        
        group.interItemSpacing = .fixed(Metrics.gridCellSpace)
        
        let headerLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayoutSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: Metrics.gridCellSpace, leading: 0, bottom: 0, trailing: 0)
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
        
        cell.configure(withMediaFile: mediaFiles[indexPath.row])
        
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: MediaCell.reuseIdentifier,
            for: indexPath) as? MediaCell
        else {
            return UICollectionReusableView()
        }
        
        if let selectedMediaFileIndex = selectedMediaFileIndex {
            header.configure(withMediaFile: mediaFiles[selectedMediaFileIndex])
        }

        return header
    }
}

// MARK: - UICollectionViewDelegate

extension NewPostView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMediaFileIndex = indexPath.row
        
        collectionView.reloadData()
    }
}
