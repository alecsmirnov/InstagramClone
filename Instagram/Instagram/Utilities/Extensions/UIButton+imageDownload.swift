//
//  UIButton+imageDownload.swift
//  Instagram
//
//  Created by Admin on 12.02.2021.
//

import UIKit

extension UIButton {
    @discardableResult func imageDownload(urlString: String) -> URLSessionDataTask? {
        let dataTask = imageView?.download(urlString: urlString) { [weak self] in
            let image = self?.imageView?.image?.withRenderingMode(.alwaysOriginal)
            
            self?.setImage(image, for: .normal)
            self?.setImage(image, for: .highlighted)
        }
        
        return dataTask
    }
}
