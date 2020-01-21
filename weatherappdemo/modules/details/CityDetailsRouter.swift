//
//  CityDetailsRouter.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 21/01/20.
//

import Foundation
import UIKit

class CityDetailsRouter: BaseRouter {
    static var mainStoryBoard:UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static func createModule() -> CityDetailsViewController{
        let viewController = CityDetailsRouter.mainStoryBoard.instantiateViewController(withIdentifier: "CityDetailsViewController") as! CityDetailsViewController
        let interactor = CityDetailsInteractor()
        let presenter = CityDetailPresenter(view: viewController,interactor: interactor)
        interactor.presenter = presenter
        viewController.presenter = presenter
        return viewController
    }
}
