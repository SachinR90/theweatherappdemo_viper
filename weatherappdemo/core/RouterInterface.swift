//
//  RouterInterface.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import Foundation
import UIKit
protocol RouterInterface {
    func popFrom(navigationController:UINavigationController?, animated: Bool)
    func dismiss(navigationController:UINavigationController?,animated: Bool)
}

class BaseRouter{
    
}

extension BaseRouter:RouterInterface{
    func popFrom(navigationController:UINavigationController?, animated: Bool) {
        let _ = navigationController?.popViewController(animated: animated)
    }
    
    func dismiss(navigationController:UINavigationController?,animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
}
