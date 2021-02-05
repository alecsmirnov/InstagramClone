//
//  UIImageView+download.swift
//  Instagram
//
//  Created by Admin on 22.01.2021.
//

import UIKit

private let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    @discardableResult func download(urlString: String) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }
        
        var dataTask: URLSessionDataTask?
        
        if let image = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
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
                
                imageCache.setObject(image, forKey: urlString as NSString)
                
                DispatchQueue.main.async() {
                    self.image = image
                }
            }
            
            dataTask?.resume()
        }
        
        return dataTask
    }
}

// URLCache variant. Doesn't work and i don't know why :(

/*
extension UIImageView {
    @discardableResult func download(urlString: String) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }

        let cache = URLCache.shared
        let urlRequest = URLRequest(url: url)

        var dataTask: URLSessionDataTask?

        if let cachedData = cache.cachedResponse(for: urlRequest)?.data,
           let image = UIImage(data: cachedData) {
            DispatchQueue.main.async() {
                self.image = image
            }
        } else {
            let urlSessionConfiguration = URLSessionConfiguration.default

            urlSessionConfiguration.requestCachePolicy = .returnCacheDataElseLoad

            let urlSession = URLSession(configuration: urlSessionConfiguration)

            dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print("Failed to download image: \(error.localizedDescription)")

                    return
                }

                if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode != 200 {
                    print("Failed to download image. Status code: \(httpURLResponse.statusCode)")

                    return
                }

                guard
                    let response = response,
                    let data = data,
                    let image = UIImage(data: data)
                else {
                    return
                }

                let cachedResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedResponse, for: urlRequest)

                DispatchQueue.main.async() {
                    self.image = image
                }
            }

            dataTask?.resume()
        }

        return dataTask
    }
}
*/
