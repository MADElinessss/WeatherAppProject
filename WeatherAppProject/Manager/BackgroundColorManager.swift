//
//  BackgroundColorManager.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/13/24.
//

import UIKit

class BackgroundColorManager {
    static let shared = BackgroundColorManager()
    
    private init() {}

    func backgroundColor(forWeatherConditionCode code: Int, atTime time: Date) -> UIColor {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let isDaytime = hour > 6 && hour < 20
        
        switch code {
        case 200...232: // Thunderstorm
            return UIColor.darkGray
        case 300...321, 500...531: // Drizzle, Rain
            return UIColor.blue
        case 600...622: // Snow
            return UIColor.white
        case 800: // Clear
            return isDaytime ? UIColor(named: "sunny_day") ?? UIColor.orange : UIColor(named: "sunny_night") ?? UIColor.orange
        case 801...804: // Clouds
            return isDaytime ? UIColor(named: "cloudy_day") ?? UIColor.orange : UIColor(named: "cloudy_night") ?? UIColor.orange
        default:
            return UIColor(named: "sunny_day") ?? UIColor.orange
        }
    }
}
