//
//  SearchViewController.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import UIKit

protocol ISearchViewController: AnyObject {
    
}

final class SearchViewController: CustomViewController<SearchView>  {
    // MARK: Properties
    
    var presenter: ISearchPresenter?
    
    // MARK: Constants
    
    private enum Metrics {
        static let searchBarVerticalSpace: CGFloat = 8
        static let searchBarHorizontalSpace: CGFloat = 8
    }
    
    // MARK: Subviews
    
    private let searchBar = UISearchBar()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBarAppearance()
        setupSearchBarLayout()
    }
}

// MARK: - Appearance

private extension SearchViewController {
    func setupSearchBarAppearance() {
        searchBar.placeholder = "Enter username"
        searchBar.searchTextField.clearButtonMode = .whileEditing
    }
}

// MARK: - Layout

private extension SearchViewController {
    func setupSearchBarLayout() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(
                equalTo: navigationBar.topAnchor,
                constant: Metrics.searchBarVerticalSpace),
            searchBar.bottomAnchor.constraint(
                equalTo: navigationBar.bottomAnchor,
                constant: -Metrics.searchBarVerticalSpace),
            searchBar.leadingAnchor.constraint(
                equalTo: navigationBar.leadingAnchor,
                constant: Metrics.searchBarHorizontalSpace),
            searchBar.trailingAnchor.constraint(
                equalTo: navigationBar.trailingAnchor,
                constant: -Metrics.searchBarHorizontalSpace),
        ])
    }
}

// MARK: - ISearchViewController

extension SearchViewController: ISearchViewController {
    
}
