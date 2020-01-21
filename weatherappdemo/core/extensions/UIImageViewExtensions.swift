//
//  UIImageViewExtensions.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import Foundation
import UIKit
let imageCache =  NSCache<NSString, UIImage>()
extension UIImageView{
    private func downloadImage(from url:URL, contentMode mode:UIView.ContentMode,maskColor:UIColor?,highlightMaskColor:UIColor?){
        contentMode = mode
        // Display activity indicator while downloading image
        showSpinner()
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async() {[weak self] in
                self?.hideSpinner()
                self?.setImage(image: cachedImage,maskColor: maskColor,highlightMaskColor: highlightMaskColor)
            }
            return
        }
        ApiService.imageRequest(url: url.absoluteString) { (data) in
            if let data = data.data, let image = UIImage(data: data){
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {[weak self] in
                    self?.setImage(image: image)
                }
            }
            DispatchQueue.main.async {[weak self] in
                self?.hideSpinner()
            }
        }
    }
    
    func setImage(image: UIImage, maskColor:UIColor? = nil, highlightMaskColor:UIColor? = nil) {
        self.image = image
        if let maskColor = maskColor {
            self.image = image.maskWithColor(color: maskColor)
        }
        if let highlightMaskColor = highlightMaskColor {
            self.highlightedImage = image.maskWithColor(color: highlightMaskColor)
        }
    }
    
    public func downloadImage(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, maskColor: UIColor? = nil, highlightMaskColor: UIColor? = nil) {
        if ((link.range(of:"http://") != nil) || (link.range(of:"https://") != nil)) {
            /*Code for load images from server.*/
            guard let url = URL(string: link) else { return }
            downloadImage(from: url, contentMode: mode, maskColor: maskColor, highlightMaskColor: highlightMaskColor)
        } else { /*Code for load images from bundle.*/
            let components = link.components(separatedBy: ".") //Seprate image extention(i.e png, jpeg, etc.) if exist in the String
            guard var imageName = components.first else { return } //Get the image  name without extention(i.e. get Account from Account.png)
            imageName = imageName.replacingOccurrences(of: " ", with: "")
            self.image = UIImage(named:imageName) //Set the image from bundle
            if let maskColor = maskColor {
                self.image = image?.maskWithColor(color: maskColor)
            }
            if let highlightMaskColor = highlightMaskColor {
                self.highlightedImage = image?.maskWithColor(color: highlightMaskColor)
            }
        }
    }
}

extension UIImage{
    func maskWithColor(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
