//
//  SearchViewController.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import UIKit

protocol ISearchViewController: AnyObject {
    func appendUser(_ user: User)
    func removeAllUsers()
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
        
        searchBar.delegate = self
        
        setupSearchBarAppearance()
        setupSearchBarLayout()
    }
}

// MARK: - Appearance

private extension SearchViewController {
    func setupSearchBarAppearance() {
        searchBar.placeholder = "Enter username"
        searchBar.searchTextField.autocapitalizationType = .none
        searchBar.searchTextField.autocorrectionType = .no
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
    func appendUser(_ user: User) {
        customView?.appendUser(user)
    }
    
    func removeAllUsers() {
        customView?.removeAllUsers()
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(didStartTyping(_:)),
            object: searchBar)
        
        perform(#selector(didStartTyping(_:)), with: searchBar, afterDelay: 0.6)
    }
    
    @objc func didStartTyping(_ searchBar: UISearchBar) {
        if let username = searchBar.text {
            presenter?.didSearchUser(with: username)
        }
    }
}
