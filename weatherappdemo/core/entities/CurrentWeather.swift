//
//  WeatherModel.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import Foundation
class CurrentWeather: Codable {
    var name:String = ""
    var icons:[Icon] = []
    var main:Main?
    var wind:Wind?
    var date:Double = 0
    private enum CodingKeys:String, CodingKey{
        case name
        case icons = "weather"
        case main
        case wind
        case date = "dt"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        }
        if let icons = try container.decodeIfPresent([Icon].self, forKey: .icons) {
            self.icons = icons
        }
        if let main = try container.decodeIfPresent(Main.self, forKey: .main) {
            self.main = main
        }
        if let wind = try container.decodeIfPresent(Wind.self, forKey: .wind) {
            self.wind = wind
        }
        if let date = try container.decodeIfPresent(Double.self, forKey: .date) {
            self.date = date
        }
    }
}

struct Icon:Codable{
    let icon: String
}

struct Main:Codable{
    let temperature:Double
    let pressure:Int
    let humidity:Int
    let maxTemp:Double
    let minTemp:Double
    
    private enum CodingKeys:String, CodingKey{
        case temperature = "temp"
        case pressure
        case humidity
        case maxTemp = "temp_max"
        case minTemp = "temp_min"
    }
}

struct Wind:Codable{
    let speed:Float
}

