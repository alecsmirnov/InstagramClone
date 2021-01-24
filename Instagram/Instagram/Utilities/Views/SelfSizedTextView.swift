//
//  SelfSizedTextView.swift
//  Instagram
//
//  Created by Admin on 23.01.2021.
//

import UIKit

final class SelfSizedTextView: UITextView, NSTextStorageDelegate {
    // MARK: Properties
    
    override var text: String! {
        didSet {
            isScrollEnabled = text.isEmpty
        }
    }
    
    // MARK: Initialization
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        
        setupTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension SelfSizedTextView {
    func setupTextView() {
        backgroundColor = .clear
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        isEditable = false
        isScrollEnabled = true
    }
}
