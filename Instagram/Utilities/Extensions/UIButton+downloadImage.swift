//
//  UIButton+downloadImage.swift
//  Instagram
//
//  Created by Admin on 12.02.2021.
//

import UIKit

extension UIButton {
    @discardableResult func downloadImage(urlString: String) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        
        var dataTask: URLSessionDataTask?
        
        if let image = ImageCachingService.shared.image(forKey: urlString) {
            let originalImage = image.withRenderingMode(.alwaysOriginal)
            
            setImage(originalImage, for: .normal)
            setImage(originalImage, for: .highlighted)
        } else {
            let urlRequest = URLRequest(url: url)
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print("Failed to download image: \(error.localizedDescription)")
                    
                    return
                }
                
                if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode != 200 {
                    print("Failed to download image. Status code: \(httpURLResponse.statusCode)")

                    return
                }
                
                guard
                    let data = data,
                    let image = UIImage(data: data)
                else {
                    return
                }
                
                ImageCachingService.shared.setImage(image, forKey: urlString)
                
                DispatchQueue.main.async() { [self] in
                    let originalImage = image.withRenderingMode(.alwaysOriginal)
                    
                    setImage(originalImage, for: .normal)
                    setImage(originalImage, for: .highlighted)
                }
            }
            
            dataTask?.resume()
        }
        
        return dataTask
    }
}
