//
//  Extensions.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/27/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageFromCache(profileImageUrl : String) {
        self.image = nil
        let url = URL(string: profileImageUrl)
        
        if let cachedImage = imageCache.object(forKey: url as! AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (Data, response, error) in
            
            if error != nil {
                print(error)
                
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: Data!){
                    imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                self.image = downloadedImage
                }
            }
            
            
            
        }).resume()
        

    }
}
