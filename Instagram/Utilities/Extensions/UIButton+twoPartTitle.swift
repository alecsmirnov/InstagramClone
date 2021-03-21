//
//  UIButton+twoPartTitle.swift
//  Instagram
//
//  Created by Admin on 11.03.2021.
//

import UIKit

extension UIButton {
    func twoPartTitle(
        firstPartText: String,
        firstPartFont: UIFont,
        firstPartColor: UIColor,
        secondPartText: String,
        secondPartFont: UIFont,
        secondPartColor: UIColor,
        partDivider: String
    ) {
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
        attributedTitleText.append(NSAttributedString(string: partDivider))
        attributedTitleText.append(secondPartAttributedText)

        setAttributedTitle(attributedTitleText, for: .normal)
    }
}
