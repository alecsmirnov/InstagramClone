//
//  SpinnerView.swift
//  Instagram
//
//  Created by Admin on 04.02.2021.
//

import UIKit

final class SpinnerView: UIView {
    // MARK: Constants
    
    private enum Metrics {
        static let containerViewSize: CGFloat = 60
        static let containerViewCornerRadius: CGFloat = 4
    }
    
    private enum Colors {
        static let viewBackground = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        static let containerViewBackground = UIColor(white: 0.96, alpha: 1)
    }
    
    private enum Constants {
        static let showAnimationDuration: TimeInterval = 0.2
        static let hideAnimationDuration: TimeInterval = 0.4
    }
    
    // MARK: Subviews
    
    private let containerView = UIView()
    private let activityIndicatorView = UIActivityIndicatorView()

    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()

        frame = UIScreen.main.bounds
    }
}

// MARK: - Public Methods

extension SpinnerView {
    func show() {
        UIView.animate(withDuration: Constants.showAnimationDuration) {
            self.alpha = 1
        }
        
        activityIndicatorView.startAnimating()
    }
    
    func hide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: Constants.hideAnimationDuration) {
            self.alpha = 0
        } completion: { _ in
            self.activityIndicatorView.stopAnimating()
            
            completion?()
        }
    }
}

// MARK: - Appearance

private extension SpinnerView {
    func setupAppearance() {
        setupContainerViewAppearance()
        setupActivityIndicatorViewAppearance()
        
        backgroundColor = Colors.viewBackground
        alpha = 0
    }
    
    func setupContainerViewAppearance() {
        containerView.backgroundColor = Colors.containerViewBackground
        containerView.layer.cornerRadius = Metrics.containerViewCornerRadius
    }
    
    func setupActivityIndicatorViewAppearance() {
        activityIndicatorView.style = .medium
        activityIndicatorView.color = .black
    }
}

// MARK: - Layout

private extension SpinnerView {
    func setupLayout() {
        addSubviews()
        
        setupContainerViewLayout()
        setupActivityIndicatorViewLayout()
    }
    
    func addSubviews() {
        addSubview(containerView)
        
        containerView.addSubview(activityIndicatorView)
    }
    
    func setupContainerViewLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Metrics.containerViewSize),
            containerView.widthAnchor.constraint(equalToConstant: Metrics.containerViewSize),
        ])
    }
    
    func setupActivityIndicatorViewLayout() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
}
