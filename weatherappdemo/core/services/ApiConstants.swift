//
//  ApiConstants.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import Foundation
class ApiConstants {
    static let BASE_URL = "https://api.openweathermap.org/data/2.5"
    static let BASE_URL_IMAGE = "http://openweathermap.org/img/w/%@.png"
    
    static let WEATHER_URL = "\(BASE_URL)/weather?q=%@&units=metric&APPID=a7829840d371315356876d72a3bd4b82"
    static let FORECAST_URL = "\(BASE_URL)/forecast?q=%@&cnt=16&units=metric&APPID=a7829840d371315356876d72a3bd4b82"
}
