//
//  UIImageExtensions.swift
//  SoTube
//
//  Created by VDAB Cursist on 23/05/17.
//  Copyright © 2017 NV Met Talent. All rights reserved.
//

extension UIImageView {
    func image(fromUrl url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, onCompletion completionHandler:  (()->())? = nil) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                if let completionHandler = completionHandler {
                    completionHandler()
                }
            }
            }.resume()
    }
    
    func image(fromLink link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, onCompletion completionHandler:  (()->())? = nil) {
        guard let url = URL(string: link) else { return }
        image(fromUrl: url, contentMode: mode, onCompletion: completionHandler)
    }
}
