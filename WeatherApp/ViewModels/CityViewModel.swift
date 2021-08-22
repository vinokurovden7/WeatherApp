//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 15.08.2021.
//

import Foundation
class CityViewModel: CityViewModelType {
    var cityArray = [""]

    init() {
        searchCity(searchString: "")
    }

    func getCityCount() -> Int {
        return cityArray.count
    }

    func searchCity(searchString: String) {
        if let dataUrl = Bundle.main.url(forResource: "city", withExtension: "json") {
            do {
                let data = try Data(contentsOf: dataUrl)
                let cityData = try JSONDecoder().decode(Cities.self, from: data)
                var cictiesArray: [City]?
                if !searchString.isEmpty {
                    cictiesArray = cityData.city.filter({ city in
                        city.name.hasPrefix(searchString)
                    })
                } else {
                    cictiesArray = cityData.city
                }
                if let cictiesArray = cictiesArray {
                    cityArray = cictiesArray.compactMap({$0.name}).sorted()
                }
            } catch {
                print(error.localizedDescription)
            }
        }

    }

    func getCityArray(index: Int) -> String {
        return cityArray.sorted(by: {$1 > $0})[index]
    }
}
