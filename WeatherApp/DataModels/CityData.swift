//
//  CityData.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 22.07.2021.
//

import Foundation

struct Cities: Codable {
    let city: [City]
}
struct City: Codable {
    let name: String
}
