//
//  UIImageView+download.swift
//  Instagram
//
//  Created by Admin on 22.01.2021.
//

import UIKit

extension UIImageView {
    func download(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let cache = URLCache.shared
        let urlRequest = URLRequest(url: url)
        
        if let cachedData = cache.cachedResponse(for: urlRequest)?.data,
           let image = UIImage(data: cachedData) {
            DispatchQueue.main.async() {
                self.image = image
            }
        } else {
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard
                    let data = data,
                    let image = UIImage(data: data),
                    let response = response,
                    error == nil
                else {
                    print("Failed to download image: \(error?.localizedDescription ?? "")")
                    
                    return
                }
                
                let cachedResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedResponse, for: urlRequest)
                
                DispatchQueue.main.async() {
                    self.image = image
                }
            }
            
            dataTask.resume()
        }
    }
}
