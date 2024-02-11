//
//  Sys.swift
//  WeatherAppProject
//
//  Created by Madeline on 2/11/24.
//

import Foundation

struct Sys: Decodable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise, sunset: Int?
}
