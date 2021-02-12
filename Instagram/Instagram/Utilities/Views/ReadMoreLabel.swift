//
//  ReadMoreLabel.swift
//  Instagram
//
//  Created by Admin on 11.02.2021.
//

import UIKit

final class ReadMoreLabel: UILabel {
    // MARK: Properties
    
    var moreText = "more"
    var moreTextFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
    var moreTextColor = UIColor.lightGray
    
    private var isAttributedText = false
    private var fullAttributedText: NSAttributedString?
    
    private var visibleTextRange: NSRange?
    
    // MARK: Constants
    
    private enum Constants {
        static let trimText = "... "
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        truncateIfNeeded()
    }
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension ReadMoreLabel {
    func truncateIfNeeded() {
        layoutIfNeeded()
        
        if isTruncatedText {
            if let text = text, text.isEmpty {
                isAttributedText = false
                fullAttributedText = NSAttributedString(string: text)
                
                addReadMoreText()
            } else {
                isAttributedText = true
                fullAttributedText = attributedText
                
                addReadMoreAttributedText()
            }
        }
    }
}

// MARK: - Private Methods

private extension ReadMoreLabel {
    var isTruncatedText: Bool {
        guard let textHeight = textHeight else { return false }
        
        return bounds.height < textHeight
    }
    
    var textHeight: CGFloat? {
        guard let text = text as NSString? else { return nil }
        
        let sizeConstraint = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: UIFont] = [.font: font]
        
        let boundingRect = text.boundingRect(
            with: sizeConstraint,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil)
        
        return boundingRect.height
    }
    
    var visibleTextLength: Int {
        guard let text = text as NSString? else { return 0 }
        
        let labelWidth = frame.width
        let labelHeight = frame.height
        
        let sizeConstraint = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: UIFont] = [.font: font]
        
        let boundingRect = text.boundingRect(
            with: sizeConstraint,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil)
        
        let textHeight = boundingRect.height
        
        if labelHeight < textHeight {
            var currentIndex = 0
            var previousIndex = 0
            
            var previousTextHeight: CGFloat = 0
            
            repeat {
                previousIndex = currentIndex
                
                if lineBreakMode == NSLineBreakMode.byCharWrapping {
                    currentIndex += 1
                } else {
                    let wordBeginIndex = currentIndex + 1
                    let rangeLength = text.length - currentIndex - 1
                    
                    let nextWordRange = NSRange(location: wordBeginIndex, length: rangeLength)
                    
                    let rangeOfCharacter = text.rangeOfCharacter(
                        from: .whitespacesAndNewlines,
                        options: [],
                        range: nextWordRange)
                    
                    let nextWordBeginIndex = rangeOfCharacter.location
                    
                    currentIndex = nextWordBeginIndex
                }
                
                let previousText = text.substring(to: currentIndex)
                let previousTextBoundingRect = previousText.boundingRect(
                    with: sizeConstraint,
                    options: .usesLineFragmentOrigin,
                    attributes: attributes,
                    context: nil)
                
                previousTextHeight = previousTextBoundingRect.height
            } while currentIndex != NSNotFound && currentIndex < text.length && previousTextHeight <= labelHeight
            
            return previousIndex
        }
        
        return text.length
    }
    
    func addReadMoreText() {
        guard let text = text as NSString? else { return }
        
        let visibleStringLength = visibleTextLength
        
        let trimmedTextRange = NSRange(location: visibleStringLength, length: text.length - visibleStringLength)
        let trimmedText = text.replacingCharacters(in: trimmedTextRange, with: "") as NSString
        
        let readMoreText = Constants.trimText + moreText
        let readMoreTextLength = readMoreText.count
        
        let trimmedReadMoreTextRange = NSRange(
            location: trimmedText.length - readMoreTextLength,
            length: readMoreTextLength)
        let trimmedReadMoreText = trimmedText.replacingCharacters(
            in: trimmedReadMoreTextRange,
            with: Constants.trimText)
        
        let attributes: [NSAttributedString.Key: UIFont] = [.font: font]
        let readMoreAttributes: [NSAttributedString.Key: Any] = [
            .font: moreTextFont,
            .foregroundColor: moreTextColor
        ]
        
        let attributedText = NSMutableAttributedString(string: trimmedReadMoreText, attributes: attributes)
        let readMoreAttributedText = NSMutableAttributedString(string: moreText, attributes: readMoreAttributes)
        
        attributedText.append(readMoreAttributedText)
        
        self.attributedText = attributedText
        
        let moreAttributedText = NSMutableAttributedString(string: Constants.trimText, attributes: attributes)
        let visibleTextRange = NSRange(
            location: visibleStringLength - moreAttributedText.length,
            length: moreAttributedText.length)
        
        self.visibleTextRange = visibleTextRange
    }
    
    func addReadMoreAttributedText() {
        guard let text = attributedText else { return }
        
        let visibleStringLength = visibleTextLength
        
        let trimmedTextRange = NSRange(location: 0, length: visibleStringLength)
        let trimmedText = text.attributedSubstring(from: trimmedTextRange)
        
        let readMoreText = Constants.trimText + moreText
        let readMoreTextLength = readMoreText.count
        
        let visibleTrimmedTextRange = NSRange(location: 0, length: trimmedText.length - readMoreTextLength)
        let visibleTrimmedText = trimmedText.attributedSubstring(from: visibleTrimmedTextRange)
        
        let trimmedReadMoreText = NSMutableAttributedString(attributedString: visibleTrimmedText)
        trimmedReadMoreText.append(NSAttributedString(string: Constants.trimText))
        
        let attributes: [NSAttributedString.Key: UIFont] = [.font: font]
        let readMoreAttributes: [NSAttributedString.Key: Any] = [
            .font: moreTextFont,
            .foregroundColor: moreTextColor
        ]
        
        let attributedText = NSMutableAttributedString(attributedString: trimmedReadMoreText)
        let readMoreAttributedText = NSMutableAttributedString(string: moreText, attributes: readMoreAttributes)

        attributedText.append(readMoreAttributedText)
        
        self.attributedText = attributedText

        let moreAttributedText = NSMutableAttributedString(string: Constants.trimText, attributes: attributes)
        let visibleTextRange = NSRange(
            location: visibleStringLength - moreAttributedText.length,
            length: moreAttributedText.length)

        self.visibleTextRange = visibleTextRange
    }
    
    func getIndex(from point: CGPoint) -> Int? {
        guard let attributedText = attributedText, 0 < attributedText.length else { return nil }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: frame.size)
        
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(
            for: point,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil)
        
        return index
    }
    
    func didTapInRange(_ point: CGPoint, targetRange: NSRange) -> Bool {
        guard let indexOfPoint = getIndex(from: point) else { return false }
        
        return targetRange.location < indexOfPoint + 1 && indexOfPoint < targetRange.location + targetRange.length + 1
    }
}

// MARK: - Gestures

private extension ReadMoreLabel {
    func setupGestures() {
        isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(_:)))
        
        addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapLabel(_ sender: UITapGestureRecognizer) {
        guard let visibleTextRange = visibleTextRange else { return }
    
        let tapLocation = sender.location(in: self)
        
        if didTapInRange(tapLocation, targetRange: visibleTextRange) {
            numberOfLines = 0
            
            if isAttributedText {
                attributedText = fullAttributedText
            } else {
                text = fullAttributedText?.string
            }
        }
    }
}
