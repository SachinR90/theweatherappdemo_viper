//
//  HomePresenter.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 21/01/20.
//

import Foundation
import UIKit
protocol HomePresenterInterface:PresenterInterface {
    func getWeatherDetails(for locations: [String])
    func weatherDetailsFetchedSuccessfully(_ weatherDetails: [CurrentWeather])
    func showError(_ message: String)
    
    // navigation
    func showCityWeatherDetails(city: CurrentWeather)
}

class HomePresenter{
    private let router:HomeRouterInterface
    private let interactor:HomeInteractorInterface
    private let view:HomeViewInterface
    
    init(router:HomeRouterInterface, view:HomeViewInterface,interactor: HomeInteractorInterface) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
}

extension HomePresenter: HomePresenterInterface{
    
    func getWeatherDetails(for locations: [String]) {
        view.showSpinner()
        interactor.fetchCurrentWeather(for: locations)
    }
    
    func weatherDetailsFetchedSuccessfully(_ weatherDetails: [CurrentWeather]) {
        view.hideSpinner()
        view.updateWeatherData(weatherDetails: weatherDetails)
    }
    
    func showError(_ message: String) {
        //todo
    }
    
    func showCityWeatherDetails(city: CurrentWeather) {
        router.navigate(to: .details(selectedCity: city),from: view.getNavigationController())
    }
}
