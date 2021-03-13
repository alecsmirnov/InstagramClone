//
//  TwoPartsButton.swift
//  Instagram
//
//  Created by Admin on 23.01.2021.
//

import UIKit

final class TwoPartsButton: UIButton {
    // MARK: Properties

    var firstPartText: String = "" {
        didSet {
            setupAppearance()
        }
    }

    var secondPartText: String = "" {
        didSet {
            setupAppearance()
        }
    }

    var firstPartFont: UIFont = .systemFont(ofSize: Constants.defaultFontSize) {
        didSet {
            setupAppearance()
        }
    }

    var secondPartFont: UIFont = .systemFont(ofSize: Constants.defaultFontSize) {
        didSet {
            setupAppearance()
        }
    }

    var firstPartColor: UIColor = .black {
        didSet {
            setupAppearance()
        }
    }

    var secondPartColor: UIColor = .black {
        didSet {
            setupAppearance()
        }
    }

    var divider: String = " " {
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
        static let defaultFontSize: CGFloat = 14

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

private extension TwoPartsButton {
    func setupAppearance() {
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: firstPartFont,
            .foregroundColor: firstPartColor]
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: secondPartFont,
            .foregroundColor: secondPartColor]

        let firstPartAttributedText = NSAttributedString(string: firstPartText, attributes: numberAttributes)
        let secondPartAttributedText = NSAttributedString(string: secondPartText, attributes: titleAttributes)

        let attributedTitleText = NSMutableAttributedString()

        attributedTitleText.append(firstPartAttributedText)
        attributedTitleText.append(NSAttributedString(string: divider))
        attributedTitleText.append(secondPartAttributedText)

        setAttributedTitle(attributedTitleText, for: .normal)
    }
}
