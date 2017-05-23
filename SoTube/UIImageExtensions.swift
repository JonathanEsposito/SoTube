//
//  UIImageExtensions.swift
//  SoTube
//
//  Created by VDAB Cursist on 23/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

extension UIImage {
    
    class func getImage(fromUrl url: String) -> UIImage? {
        var returnImage: UIImage?
        if let imageURL = URL(string: url) {
            let imageRequest = URLRequest(url: imageURL)
            let imageSession = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
            imageSession.dataTask(with: imageRequest) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        returnImage = image
                    }
                }
                }.resume()
        }
        return returnImage
    }
    
}
