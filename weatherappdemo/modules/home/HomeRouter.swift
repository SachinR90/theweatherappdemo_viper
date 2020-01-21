//
//  HomeRouter.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import Foundation
import UIKit
enum HomeNavigationOptions{
    case details(selectedCity: CurrentWeather)
}
protocol HomeRouterInterface: BaseRouter {
    func navigate(to option: HomeNavigationOptions, from viewController:UINavigationController?)
}

class HomeRouter: BaseRouter {
    static var mainStoryBoard:UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static func createModule() -> HomeViewController{
        let viewController = HomeRouter.mainStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(router: router, view: viewController,interactor: interactor)
        interactor.presenter = presenter
        viewController.presenter = presenter
        return viewController
    }
}

extension HomeRouter:HomeRouterInterface{
    func navigate(to option: HomeNavigationOptions, from viewController:UINavigationController?) {
        switch option {
        case .details(let city):
            let module = CityDetailsRouter.createModule()
            module.curreWeather = city
            viewController?.pushViewController(module, animated: true)
        }
    }
}
