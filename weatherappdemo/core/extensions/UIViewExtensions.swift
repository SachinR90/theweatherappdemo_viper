//
//  UIViewExtensions.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import Foundation
import UIKit
extension UIView{
    static let spinnerViewTag = 999
    func showSpinner(style: UIActivityIndicatorView.Style = .gray,color: UIColor? = nil) {
        var loading = viewWithTag(UIView.spinnerViewTag) as? UIActivityIndicatorView
        if loading == nil {
            loading = UIActivityIndicatorView(style: style)
        }else{
            loading?.removeFromSuperview()
        }
        if let color = color {
            loading?.color = color
        }
        
        loading?.translatesAutoresizingMaskIntoConstraints = false
        loading!.startAnimating()
        loading!.hidesWhenStopped = true
        loading?.tag = UIView.spinnerViewTag
        addSubview(loading!)
        loading?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loading?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func hideSpinner() {
        let loading = viewWithTag(UIView.spinnerViewTag) as? UIActivityIndicatorView
        loading?.stopAnimating()
        loading?.removeFromSuperview()
    }
}
