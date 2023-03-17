//
//  ImageCacheManager.swift
//  MyPetD
//
//  Created by heyji on 2022/10/06.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() { }
}

extension UIImageView {
    func setImageURL(_ url: String) {
        let cacheKey = NSString(string: url)
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) { // 해당 key에 캐시이미지가 저장되어 있으면 이미지를 사용
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: url) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let _ = error {
                        DispatchQueue.main.async {
                            self.image = UIImage()
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data, let image = UIImage(data: data) {
                            ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                            self.image = image
                        }
                    }
                }.resume()
            }
        }
    }
}
