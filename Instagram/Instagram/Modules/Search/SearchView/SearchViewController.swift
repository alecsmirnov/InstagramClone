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
    
    func reloadData()
    
    func setupSearchAppearance()
    func setupNoResultAppearance()
    func setupResultAppearance()
}

final class SearchViewController: CustomViewController<SearchView>  {
    // MARK: Properties
    
    var presenter: ISearchPresenter?
    
    // MARK: Constants
    
    private enum Metrics {
        static let searchBarHorizontalSpace: CGFloat = 8
    }
    
    private enum Constants {
        static let searchBarInputDelay = 0.6
    }
    
    // MARK: Subviews
    
    private let searchBar = UISearchBar()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView?.delegate = self
        searchBar.delegate = self
        
        setupSearchBarAppearance()
        setupSearchBarLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        presenter?.viewWillDisappear()
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
            searchBar.topAnchor.constraint(equalTo: navigationBar.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
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
    
    func reloadData() {
        customView?.reloadData()
    }
    
    func setupSearchAppearance() {
        customView?.state = .search
    }
    
    func setupNoResultAppearance() {
        customView?.state = .noResult
    }
    
    func setupResultAppearance() {
        customView?.state = .result
    }
}

// MARK: - SearchViewDelegate

extension SearchViewController: SearchViewDelegate {
    func searchView(_ searchView: SearchView, didSelectUser user: User) {
        presenter?.didSelectUser(user)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(didStartTyping(_:)),
            object: searchBar)
        
        perform(#selector(didStartTyping(_:)), with: searchBar, afterDelay: Constants.searchBarInputDelay)
    }
    
    @objc func didStartTyping(_ searchBar: UISearchBar) {
        if let username = searchBar.text {
            presenter?.didSearchUser(with: username)
        }
    }
}
