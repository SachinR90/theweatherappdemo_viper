//
//  CurrentWeatherResponse.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import Foundation
class ForecastWeatherResponse: Codable {
    var list:[CurrentWeather]?
    var count:Int = 0
    var city:City?
    private enum CodingKeys:String,CodingKey{
        case list
        case count = "cnt"
        case city
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let list = try container.decodeIfPresent([CurrentWeather].self, forKey: .list) {
            self.list = list
        }
        if let count = try container.decodeIfPresent(Int.self, forKey: .count) {
            self.count = count
        }
        if let city = try container.decodeIfPresent(City.self, forKey: .city) {
            self.city = city
        }
    }
}

struct City:Codable{
    let name:String
}
