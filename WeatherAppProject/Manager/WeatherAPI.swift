//
//  WeatherAPI.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import Foundation

enum WeatherAPI {
    case current(lat: String, lon: String)
    case forecast(lat: String, lon: String)
    case icon
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5"
    }
    
    var endPoint: URL {
        switch self {
        case .current(let lat, let lon):
            return URL(string: "\(baseURL)/weather?lat=\(lat)&lon=\(lon)&appid=\(APIKey.apikey)")!
        case .forecast(let lat, let lon):
            return URL(string: "\(baseURL)/forecast?lat=\(lat)&lon=\(lon)&appid=\(APIKey.apikey)")!
        case .icon:
            return URL(string: baseURL + "/weather-conditions")!
        }
    }
}
