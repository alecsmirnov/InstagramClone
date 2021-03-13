//
//  EditProfileUsernameView.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

protocol EditProfileUsernameViewDelegate: AnyObject {
    func editProfileUsernameViewEnableEditButton(_ editProfileUsernameView: EditProfileUsernameView)
    func editProfileUsernameViewDisableEditButton(_ editProfileUsernameView: EditProfileUsernameView)
    func editProfileUsernameView(
        _ editProfileUsernameView: EditProfileUsernameView,
        usernameDidChange username: String?)
}

final class EditProfileUsernameView: UIView {
    // MARK: Properties
    
    weak var delegate: EditProfileUsernameViewDelegate?
    
    var username: String? {
        get {
            return usernameTextField.text
        }
        set {
            guard let username = newValue else { return }
            
            usernameTextField.text = String(username)
        }
    }
    
    // MARK: Constants
    
    private enum Metrics {
        static let usernameTextFieldFontSize: CGFloat = 16
        static let usernameTextFieldLeadingSpace: CGFloat = 6
        static let usernameTextFieldVerticalSpace: CGFloat = 8
        
        static let activityIndicatorViewHorizontalSpace: CGFloat = 17
        
        static let separatorViewHorizontalSpace: CGFloat = 10
        static let separatorViewHeight: CGFloat = 0.5
    }
    
    private enum Constants {
        static let textInputDelay = 0.6
    }
    
    // MARK: Subviews
    
    private let usernameTextField = UITextField()
    private let activityIndicatorView = UIActivityIndicatorView()
    private let separatorView = UIView()
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
        setupLayout()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension EditProfileUsernameView {
    func showActivityIndicator() {
        activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - Appearance

private extension EditProfileUsernameView {
    func setupAppearance() {
        backgroundColor = .systemBackground
        
        setupUsernameTextFieldAppearance()
        setupActivityIndicatorViewAppearance()
        setupSeparatorViewAppearance()
    }
    
    func setupUsernameTextFieldAppearance() {
        usernameTextField.font = .systemFont(ofSize: Metrics.usernameTextFieldFontSize)
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .none
        usernameTextField.becomeFirstResponder()
        
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(didStartTyping(_:)),
            object: textField)
        
        perform(#selector(didStartTyping(_:)), with: textField, afterDelay: Constants.textInputDelay)
    }
    
    @objc func didStartTyping(_ textField: UITextField) {
        delegate?.editProfileUsernameView(self, usernameDidChange: textField.text)
    }
    
    func setupActivityIndicatorViewAppearance() {
        activityIndicatorView.style = .medium
    }
    
    func setupSeparatorViewAppearance() {
        separatorView.backgroundColor = .systemBlue
    }
}

// MARK: - Layout

private extension EditProfileUsernameView {
    func setupLayout() {
        setupSubviews()
        
        setupUsernameTextFieldLayout()
        setupActivityIndicatorViewLayout()
        setupSeparatorViewLayout()
    }
    
    func setupSubviews() {
        addSubview(usernameTextField)
        addSubview(activityIndicatorView)
        addSubview(separatorView)
    }
    
    func setupUsernameTextFieldLayout() {
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: Metrics.usernameTextFieldVerticalSpace),
            usernameTextField.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.usernameTextFieldLeadingSpace),
        ])
    }
    
    func setupActivityIndicatorViewLayout() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: usernameTextField.topAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: usernameTextField.bottomAnchor),
            activityIndicatorView.leadingAnchor.constraint(
                equalTo: usernameTextField.trailingAnchor,
                constant: Metrics.activityIndicatorViewHorizontalSpace),
            activityIndicatorView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -Metrics.activityIndicatorViewHorizontalSpace),
            activityIndicatorView.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor),
            activityIndicatorView.widthAnchor.constraint(equalTo: usernameTextField.heightAnchor),
        ])
    }
    
    func setupSeparatorViewLayout() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(
                equalTo: usernameTextField.bottomAnchor,
                constant: Metrics.usernameTextFieldVerticalSpace - 1),
            separatorView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: Metrics.separatorViewHorizontalSpace),
            separatorView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -Metrics.separatorViewHorizontalSpace),
            separatorView.heightAnchor.constraint(equalToConstant: Metrics.separatorViewHeight),
        ])
    }
}

// MARK: - Gestures

private extension EditProfileUsernameView {
    func setupGestures() {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        
//        addGestureRecognizer(tapGestureRecognizer)
    }
    
//    @objc func dismissKeyboard() {
//        endEditing(true)
//    }
}
