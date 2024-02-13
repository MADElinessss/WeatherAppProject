//
//  City.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/13/24.
//

import Foundation

struct CityList: Codable {
    let id: Int
    let name: String
    let country: String
    let coord: Coordinate

    struct Coordinate: Codable {
        let lon: Double
        let lat: Double
    }
}
