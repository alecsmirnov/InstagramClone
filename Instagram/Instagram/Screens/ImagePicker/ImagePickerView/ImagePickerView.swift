//
//  ImagePickerView.swift
//  Instagram
//
//  Created by Admin on 28.01.2021.
//

import UIKit

protocol ImagePickerViewProtocol: UIView {
    var cellSize: CGSize { get }
    
    func setHeaderImage(_ image: UIImage)
    func appendImages(_ images: [UIImage])
    
    func getHeaderImage() -> UIImage?
    
    func insertNewItems(count: Int)
}

protocol ImagePickerViewOutputProtocol: AnyObject {
    func didRequestImage()
    func didSelectImage(at index: Int)
}

final class ImagePickerView: UIView {
    // MARK: Properties
    
    weak var output: ImagePickerViewOutputProtocol?
    
    private var previousSelectedIndex: Int?
    
    private let collectionViewDataSource = ImagePickerCollectionViewDataSource()
    private let collectionViewDelegate = ImagePickerCollectionViewDelegate()
    
    // MARK: Constants
    
    private(set) lazy var cellSize = CGSize(
        width: UIScreen.main.bounds.width / CGFloat(Constants.columnsCount),
        height: UIScreen.main.bounds.width / CGFloat(Constants.columnsCount))
    
    private enum Metrics {
        static let gridCellSpace: CGFloat = 1.2
    }
    
    private enum Constants {
        static let columnsCount = 4
        
        static let selectedCellAlpha: CGFloat = 0.4
        static let unselectedCellAlpha: CGFloat = 1
    }
    
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

extension ImagePickerView: ImagePickerViewProtocol {
    func setHeaderImage(_ image: UIImage) {
        guard let headerView = getHeaderView() else { return }
        
        headerView.configure(with: image)
    }
    
    func appendImages(_ images: [UIImage]) {
        collectionViewDataSource.appendImages(images)
    }
    
    func getHeaderImage() -> UIImage? {
        guard
            let headerView = getHeaderView(),
            let croppedImage = headerView.getCroppedImage()
        else {
            return nil
        }
        
        return croppedImage
    }
    
    func insertNewItems(count: Int) {
        let itemsCount = collectionViewDataSource.imagesCount - count
        
        if 1 < itemsCount {
            let lastRowIndex = itemsCount
            let indexPaths = (0..<count).map { IndexPath(row: $0 + lastRowIndex, section: 0) }
            
            collectionView.insertItems(at: indexPaths)
        } else {
            collectionView.reloadData()
        }
    }
}

// MARK: - Private Methods

private extension ImagePickerView {
    func getHeaderView() -> ImageHeaderView? {
        let headerView = collectionView.visibleSupplementaryViews(
            ofKind: UICollectionView.elementKindSectionHeader).first as? ImageHeaderView
        
        return headerView
    }
}

// MARK: - Appearance

private extension ImagePickerView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupCollectionViewAppearance()
    }
    
    func setupCollectionViewAppearance() {
        collectionView.backgroundColor = .clear
        collectionView.delaysContentTouches = false
                
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionView.register(
            ImageHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ImageHeaderView.reuseIdentifier)
        
        setupCollectionViewDataSource()
        setupCollectionViewDelegate()
    }
    
    func changeCellSelection(newCellIndex: Int, previousCellIndex: Int?) {
        if let previousCellIndex = previousCellIndex {
            let previousCellIndexPath = IndexPath(row: previousCellIndex, section: 0)
            let previousCell = collectionView.cellForItem(at: previousCellIndexPath)
            
            previousCell?.contentView.alpha = Constants.unselectedCellAlpha
        }
        
        let newCellIndexPath = IndexPath(row: newCellIndex, section: 0)
        let newCell = collectionView.cellForItem(at: newCellIndexPath)
        
        newCell?.contentView.alpha = Constants.selectedCellAlpha
    }
}

// MARK: - Layout

private extension ImagePickerView {
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
        
        collectionView.collectionViewLayout = ImagePickerView.createCollectionViewCompositionalLayout()
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

// MARK: - CollectionViewDataSource

private extension ImagePickerView {
    func setupCollectionViewDataSource() {
        collectionView.dataSource = collectionViewDataSource
        
        collectionViewDataSource.lastCellPresentedCompletion = { [weak self] in
            self?.output?.didRequestImage()
        }
    }
}

// MARK: - CollectionViewDelegate

private extension ImagePickerView {
    func setupCollectionViewDelegate() {
        collectionView.delegate = collectionViewDelegate
        
        collectionViewDelegate.selectCellAtIndexCompletion = { [weak self] index in
            self?.selectCell(at: index)
        }
        
        collectionViewDelegate.willDisplayCellAtIndexCompletion = { [weak self] cell, index in
            self?.willDisplayCell(cell, at: index)
        }
    }
    
    func selectCell(at index: Int) {
        if let image = collectionViewDataSource.getImage(at: index) {
            setHeaderImage(image)
        }
        
        changeCellSelection(newCellIndex: index, previousCellIndex: previousSelectedIndex)
        previousSelectedIndex = index
        
        let topIndexPath = IndexPath(row: 0, section: 0)
        collectionView.scrollToItem(at: topIndexPath, at: .bottom, animated: true)
        
        output?.didSelectImage(at: index)
    }
    
    func willDisplayCell(_ cell: UICollectionViewCell, at index: Int) {
        guard previousSelectedIndex == nil, index == 0 else { return }
        
        cell.contentView.alpha = Constants.selectedCellAlpha
        previousSelectedIndex = index
        
        output?.didSelectImage(at: index)
    }
}
