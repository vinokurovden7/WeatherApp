//
//  CityViewModelType.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 15.08.2021.
//

import Foundation
protocol CityViewModelType {
    func getCityCount() -> Int
    func searchCity(searchString: String)
    func getCityArray(index: Int) -> String
}
