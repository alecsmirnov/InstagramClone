//
//  StatisticButton.swift
//  Instagram
//
//  Created by Admin on 23.01.2021.
//

import UIKit

final class StatisticButton: UIButton {
    // MARK: Properties
    
    var numberText: String = "0" {
        didSet {
            setupAppearance()
        }
    }
    
    var titleText: String = "stat" {
        didSet {
            setupAppearance()
        }
    }
    
    var numberFontSize: CGFloat = 16 {
        didSet {
            setupAppearance()
        }
    }
    
    var titleFontSize: CGFloat = 14 {
        didSet {
            setupAppearance()
        }
    }
    
    var numberColor: UIColor = .black {
        didSet {
            setupAppearance()
        }
    }
    
    var titleColor: UIColor = .black {
        didSet {
            setupAppearance()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard oldValue != isHighlighted else { return }
            
            UIView.animate(withDuration: Constants.highlightAnimationDuration) {
                self.alpha = self.isHighlighted ? Constants.highlightAlpha : Constants.defaultAlpha
            }
        }
    }
    
    // MARK: Constants
    
    private enum Constants {
        static let highlightAnimationDuration = 0.3
        
        static let defaultAlpha: CGFloat = 1
        static let highlightAlpha: CGFloat = 0.2
    }
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension StatisticButton {
    func setupAppearance() {
        setupTextAppearance()
        setupTitleLabelAppearance()
    }
    
    func setupTextAppearance() {
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: numberFontSize),
            .foregroundColor: numberColor,
        ]
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: titleFontSize),
            .foregroundColor: titleColor,
        ]
        
        let numberAttributedText = NSAttributedString(string: numberText, attributes: numberAttributes)
        let titleAttributedText = NSAttributedString(string: titleText, attributes: titleAttributes)
        
        let attributedTitleText = NSMutableAttributedString()
        
        attributedTitleText.append(numberAttributedText)
        attributedTitleText.append(NSAttributedString(string: "\n"))
        attributedTitleText.append(titleAttributedText)
        
        setAttributedTitle(attributedTitleText, for: .normal)
    }
    
    func setupTitleLabelAppearance() {
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
    }
}
