//
//  CityDetailPresenter.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 21/01/20.
//

import Foundation

protocol CityDetailPresenterInterface:PresenterInterface {
    func getForecast(for city:String)
    func forecastFetchedSuccessfully(_ forecastResponse:ForecastWeatherResponse)
}

class CityDetailPresenter {
    private let interactor:CitytDetailsInteractorInterface
    private let view:CityDetailViewInterface
    
    init(view:CityDetailViewInterface,interactor: CitytDetailsInteractorInterface) {
        self.interactor = interactor
        self.view = view
    }
}

extension CityDetailPresenter: CityDetailPresenterInterface{
    func forecastFetchedSuccessfully(_ forecastResponse: ForecastWeatherResponse) {
         self.view.hideSpinner()
        self.view.updateForecastData(forecastResponse: forecastResponse)
    }
    
    func getForecast(for city: String) {
        interactor.fetchForecastWeather(for: city)
    }
}
