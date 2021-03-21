//
//  SharePostServiceProtocol.swift
//  Instagram
//
//  Created by Admin on 16.03.2021.
//

import UIKit

protocol SharePostServiceProtocol: AnyObject {
    func sharePost(withImage image: UIImage, caption: String?, completion: @escaping (Error?) -> Void)
}
