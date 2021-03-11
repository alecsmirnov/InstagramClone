//
//  MaterialTextField.swift
//  Instagram
//
//  Created by Admin on 07.03.2021.
//

import UIKit

final class MaterialTextField: UITextField {
    // MARK: Properties
    
    override var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let contentHeight = textInsets.top + textHeight + textInsets.bottom
        let contentSize = CGSize(width: bounds.width, height: contentHeight)
        
        return contentSize
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    private var textInsets: UIEdgeInsets {
        let textHeight = Metrics.verticalSpace + fontSize
        let textInsets = UIEdgeInsets(top: textHeight, left: 0, bottom: Metrics.verticalSpace, right: 0)
        
        return textInsets
    }
    
    private var fontSize: CGFloat {
        return font?.pointSize ?? 0
    }
    
    private var textHeight: CGFloat {
        return font?.lineHeight ?? 0
    }
    
    private var isEmpty: Bool {
        return text?.isEmpty ?? true
    }
    
    // MARK: Constants
    
    private enum Metrics {
        static let verticalSpace: CGFloat = 8
        static let placeholderLabelScale: CGFloat = 0.85
        static let bottomBorderHeight: CGFloat = 1
    }
    
    private enum Colors {
        static let active = UIColor.black
        static let inactive = UIColor.lightGray
    }
    
    private enum Constants {
        static let animationDuration: TimeInterval = 0.25
    }
    
    // MARK: Subviews
    
    private let placeholderLabel = UILabel()
    private let bottomBorder = UIView()
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updatePlaceholderLabel(animated: false)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        setupPlaceholderLabelLayout()
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Appearance

private extension MaterialTextField {
    func setupAppearance() {
        placeholderLabel.textColor = Colors.inactive
        bottomBorder.backgroundColor = Colors.inactive
        
        addAction(UIAction { [weak self] _ in
            self?.updatePlaceholderLabel()
            self?.updateBorderStyle()
        }, for: .allEditingEvents)
    }
    
    private func updatePlaceholderLabel(animated: Bool = true) {
        let scale = Metrics.placeholderLabelScale
        
        let offsetY = Metrics.verticalSpace + fontSize
        let translationX = -placeholderLabel.bounds.width * (1 - scale) / 2
        let translationY = -placeholderLabel.bounds.height * (1 - scale) / 2 - offsetY

        let transform = CGAffineTransform(translationX: translationX, y: translationY).scaledBy(x: scale, y: scale)
        
        UIView.animate(withDuration: animated ? Constants.animationDuration : 0) { [self] in
            placeholderLabel.transform = (isFirstResponder || !isEmpty) ? transform : .identity
        }
    }
    
    func updateBorderStyle() {
        UIView.animate(withDuration: Constants.animationDuration) { [self] in
            bottomBorder.backgroundColor = isFirstResponder ? Colors.active : Colors.inactive
        }
    }
}

// MARK: - Layout

private extension MaterialTextField {
    func setupLayout() {
        setupSubviews()
        
        setupBottomBorderLayout()
    }
    
    func setupSubviews() {
        addSubview(placeholderLabel)
        addSubview(bottomBorder)
    }
    
    func setupPlaceholderLabelLayout() {
        placeholderLabel.transform = .identity
        placeholderLabel.frame = bounds.inset(by: textInsets)
    }
    
    func setupBottomBorderLayout() {
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: Metrics.bottomBorderHeight),
        ])
    }
}
