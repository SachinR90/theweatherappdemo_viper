//
//  CityDetailsINteractor.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 21/01/20.
//

import Foundation

protocol CitytDetailsInteractorInterface:InteractorInterface {
    func fetchForecastWeather(for cityName:String)
}

class CityDetailsInteractor {
    var presenter:CityDetailPresenterInterface!
}

extension CityDetailsInteractor: CitytDetailsInteractorInterface{
    func fetchForecastWeather(for cityName:String){
        let buildUrl = ApiConstants.FORECAST_URL.replacingOccurrences(of: "%@", with:cityName).replacingOccurrences(of: " ", with: "%20")
        ApiService.request(url: buildUrl, requestType: .get, requiredRequestHeaders: [:], parameters: nil) { (result:Result<ForecastWeatherResponse,ResponseError>) in
            DispatchQueue.main.async {[weak self] in
                switch(result){
                case .success(let details):
                    self?.presenter.forecastFetchedSuccessfully(details)
                case .failure(.errorInfo(let code, let description)):
                    print("\(code),\(description)")
                }
            }
        }
    }
}
