//
//  SpinnerButton.swift
//  Instagram
//
//  Created by Admin on 11.03.2021.
//

import UIKit

protocol SpinnerButtonProtocol: UIButton {
    var activityIndicatorStyle: UIActivityIndicatorView.Style { get set }
    var activityIndicatorColor: UIColor { get set }
    
    func startAnimatingActivityIndicator()
    func stopAnimatingActivityIndicator()
}

final class SpinnerButton: UIButton {
    // MARK: Subviews
    
    private var titleColorBeforeActivity: UIColor?
    
    private let activityIndicatorView = UIActivityIndicatorView()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Interface

extension SpinnerButton: SpinnerButtonProtocol {
    var activityIndicatorStyle: UIActivityIndicatorView.Style {
        get {
            return activityIndicatorView.style
        }
        set {
            activityIndicatorView.style = newValue
        }
    }
    
    var activityIndicatorColor: UIColor {
        get {
            return activityIndicatorView.color
        }
        set {
            activityIndicatorView.color = newValue
        }
    }
    
    func startAnimatingActivityIndicator() {
        titleColorBeforeActivity = titleColor(for: .normal)
        
        setTitleColor(.clear, for: .normal)
        activityIndicatorView.startAnimating()
    }
    
    func stopAnimatingActivityIndicator() {
        guard let titleColor = titleColorBeforeActivity else {
            return
        }
        
        setTitleColor(titleColor, for: .normal)
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - Layout

private extension SpinnerButton {
    func setupLayout() {
        addSubviews()
        setupActivityIndicatorViewLayout()
    }
    
    func addSubviews() {
        addSubview(activityIndicatorView)
    }
    
    func setupActivityIndicatorViewLayout() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            activityIndicatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
