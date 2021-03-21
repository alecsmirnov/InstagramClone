//
//  SearchViewController.swift
//  Instagram
//
//  Created by Admin on 15.02.2021.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func appendUsers(_ users: [User])
    func removeAllUsers()
    
    func insertNewRows(count: Int)
    func endRefreshing()
    
    func setupSearchAppearance()
    func setupNoResultAppearance()
    func setupResultAppearance()
}

protocol SearchViewControllerOutputProtocol: AnyObject {
    func didPullToRefresh()
    func didRequestUsers()
    
    func didSearchUser(by username: String)
    func didSelectUser(_ user: User)
}

final class SearchViewController: CustomViewController<SearchView>  {
    // MARK: Properties
    
    var output: SearchViewControllerOutputProtocol?
    
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
        
        customView?.output = self
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
    }
}

// MARK: - SearchViewController Interface

extension SearchViewController: SearchViewControllerProtocol {
    func appendUsers(_ users: [User]) {
        customView?.appendUsers(users)
    }
    
    func removeAllUsers() {
        customView?.removeAllUsers()
    }
    
    func insertNewRows(count: Int) {
        customView?.insertNewRows(count: count)
    }
    
    func endRefreshing() {
        customView?.endRefreshing()
    }
    
    func setupSearchAppearance() {
        customView?.setupSearchAppearance()
    }
    
    func setupNoResultAppearance() {
        customView?.setupNoResultAppearance()
    }
    
    func setupResultAppearance() {
        customView?.setupResultAppearance()
    }
}

// MARK: - SearchView Output

extension SearchViewController: SearchViewOutputProtocol {
    func didPullToRefresh() {
        output?.didPullToRefresh()
    }
    
    func didRequestUser() {
        output?.didRequestUsers()
    }
    
    func didSelectUser(_ user: User) {
        output?.didSelectUser(user)
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
        guard let username = searchBar.text else { return }
        
        output?.didSearchUser(by: username)
    }
}
