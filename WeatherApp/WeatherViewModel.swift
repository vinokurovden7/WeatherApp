//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 09.07.2021.
//

import Foundation
class WeatherViewModel {
    
    var weatherData: WeatherData?
    
    func getWeather(from city: String = "Нижняя Тура", completion: @escaping () -> ()) {
        let networkManager = NetworkManager()
        networkManager.getWeather(from: city) { weatherData in
            self.weatherData = weatherData
            completion()
        }
    }
    
    
    func getWindSpeedToday() -> String {
        if let weatherData = weatherData {
            if let windSpeed = weatherData.currentConditions.windspeed {
                return "\(windSpeed) km/h"
            } else {
                return "No info"
            }
        } else {
            return ""
        }
    }
    
    func getTempToday() -> [String:String] {
        var todayWeatherTepmDictionary: [String:String] = [:]
        if let weatherData = weatherData {
            todayWeatherTepmDictionary["temp"] = "\(weatherData.currentConditions.temp)°"
            todayWeatherTepmDictionary["feelslike"] = "Feels like \(weatherData.currentConditions.feelslike)°"
        }
        return todayWeatherTepmDictionary
    }
    
    func getImageToday() -> String {
        if let weatherData = weatherData {
            return weatherData.currentConditions.icon
        } else {
            return ""
        }
    }
    
    func getConditions() -> String {
        if let weatherData = weatherData {
            return weatherData.currentConditions.conditions
        } else {
            return "No info"
        }
    }
    
    func getHumidity() -> String {
        if let weatherData = weatherData {
            return "\(weatherData.currentConditions.humidity)%"
        } else {
            return ""
        }
    }
    
    func getVisisbility() -> String {
        if let weatherData = weatherData {
            if let visibility = weatherData.currentConditions.visibility {
                return "\(visibility) km"
            } else {
                return "No info"
            }
        } else {
            return ""
        }
    }
    
    func getUVIndex() -> String {
        if let weatherData = weatherData {
            if let uvindex = weatherData.currentConditions.uvindex {
                return "\(uvindex)"
            } else {
                return "No info"
            }
        } else {
            return ""
        }
    }
    
    func getCity() -> String {
        if let weatherData = weatherData {
            return "\(weatherData.address)"
        } else {
            return ""
        }
    }
    
    func getDopParamWeather(for row: Int) -> String {
        
        switch row {
            case 0:
                return getWindSpeedToday()
            case 1:
                return getHumidity()
            case 2:
                return getVisisbility()
            case 3:
                return getUVIndex()
            case 4:
                if let weatherData = weatherData {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    let time = Date(timeIntervalSince1970: weatherData.currentConditions.sunriseEpoch)
                    return "\(dateFormatter.string(from: time))"
                }
            case 5:
                if let weatherData = weatherData {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    let time = Date(timeIntervalSince1970: weatherData.currentConditions.sunsetEpoch)
                    return "\(dateFormatter.string(from: time))"
                }
            default:
                break
        }

        return ""
    }
    
    func getCountParam() -> Int {
        return 6
    }
    
    func getHoursStatistics(from day: Days) -> [Hours] {
        return day.hours.filter({!($0.icon?.isEmpty ?? false)})
    }
    
    func getDay(from index: Int = 0) -> Days? {
        if let weatherData = weatherData {
            return weatherData.days[index]
        } else {
            return nil
        }
    }
    
    func getDays() -> [Days] {
        if let weatherData = weatherData {
            return weatherData.days
        } else {
            return []
        }
    }
    
}
