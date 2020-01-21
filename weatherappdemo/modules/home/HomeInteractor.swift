//
//  HomeInteractor.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import Foundation

protocol HomeInteractorInterface:InteractorInterface {
    func fetchCurrentWeather(for locations:[String])
}

class HomeInteractor{
    var presenter:HomePresenterInterface!
}

extension HomeInteractor{
    func fetchCurrentWeather(for location:String, completion:@escaping (Result<CurrentWeather,ResponseError>)->Void){
        let buildUrl = ApiConstants.WEATHER_URL.replacingOccurrences(of: "%@", with: location).replacingOccurrences(of: " ", with: "%20")
        ApiService.request(url: buildUrl, requestType: .get, requiredRequestHeaders: [:], parameters: nil, completion: completion)
    }
}

//MARK:- Implement the interface
extension HomeInteractor:HomeInteractorInterface{
    func fetchCurrentWeather(for locations: [String]) {
        var weatherDetails:[CurrentWeather] = []
        let dispatchGroup = DispatchGroup()
        for location in locations{
            dispatchGroup.enter()
            fetchCurrentWeather(for: location) { (result) in
                switch(result){
                case .success(let details):
                    weatherDetails.append(details)
                    dispatchGroup.leave()
                case .failure(.errorInfo(let code, let description)):
                    print("\(code),\(description)")
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main){
            self.presenter.weatherDetailsFetchedSuccessfully(weatherDetails)
        }
    }
}

