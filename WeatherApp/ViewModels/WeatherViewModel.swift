//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 09.07.2021.
//

import Foundation
class WeatherViewModel: WeatherViewModelType {
    
    var weatherData: WeatherData?
    
    /// Получить погоду с сервера
    /// - Parameters:
    ///   - city: Город, для которого нужно получить погоду
    ///   - completion: замыкание
    /// - Returns: Полученные данные о погоде
    func getWeather(from city: String?, completion: @escaping (Bool) -> ()) {
        let networkManager = NetworkManager()
        if let city = city {
            networkManager.getWeather(from: city) { weatherData in
                self.weatherData = weatherData
                completion(true)
            }
        } else {
            let locationManager = LocationManager()
            let latitude = locationManager.getCurrentLocation().latitude
            let longitude = locationManager.getCurrentLocation().longitude
            switch locationManager.getLocationAutorizationStatus() {
                case .denied, .notDetermined, .restricted:
                    completion(false)
                default:
                    networkManager.getWeather(from: (latitude: latitude, longitude: longitude)) { weatherData in
                        self.weatherData = weatherData
                        completion(true)
                    }
            }
        }
    }
    
    /// Получить скорость ветра
    /// - Returns: Скорость ветра
    func getWindSpeedToday() -> String {
        if let weatherData = weatherData {
            if let windSpeed = weatherData.currentConditions.windspeed {
                return "\(Int(windSpeed)) \(NSLocalizedString("km/h", comment: ""))"
            } else {
                return "No info"
            }
        } else {
            return ""
        }
    }
    
    /// Получить текущую температуру
    /// - Returns: Словарь температур
    func getTempToday() -> [String:String] {
        var todayWeatherTepmDictionary: [String:String] = [:]
        if let weatherData = weatherData {
            todayWeatherTepmDictionary["temp"] = "\(Int(weatherData.currentConditions.temp))°"
            todayWeatherTepmDictionary["feelslike"] = " \(NSLocalizedString("FeelsLike", comment: "")) \(Int(weatherData.currentConditions.feelslike))°"
        }
        return todayWeatherTepmDictionary
    }
    
    /// Получить изображение для текущей погоды
    /// - Returns: Наименование изображения
    func getImageToday() -> String {
        if let weatherData = weatherData {
            return weatherData.currentConditions.icon
        } else {
            return ""
        }
    }
    
    /// Получить текстовое описание погоды
    /// - Returns: Описание погоды
    func getConditions() -> String {
        if let weatherData = weatherData {
            return weatherData.currentConditions.conditions
        } else {
            return "No info"
        }
    }
    
    /// Получить влажность
    /// - Returns: Влажность
    func getHumidity() -> String {
        if let weatherData = weatherData {
            return "\(Int(weatherData.currentConditions.humidity)) %"
        } else {
            return ""
        }
    }
    
    /// Получить дальность видимости
    /// - Returns: Дальность видимости
    func getVisisbility() -> String {
        if let weatherData = weatherData {
            if let visibility = weatherData.currentConditions.visibility {
                return "\(Int(visibility)) \(NSLocalizedString("km", comment: ""))"
            } else {
                return "No info"
            }
        } else {
            return ""
        }
    }
    
    /// Получить ультрафиолетовый индекс
    /// - Returns: Ультрафиолетовый индекс
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
    
    /// Получить название города, относительно которого отображаются данные
    /// - Returns: Наименование города
    func getCity(completion: @escaping (String) -> Void) {
        if let weatherData = weatherData {
            if weatherData.address.contains(",") {
                let locationManager = LocationManager()
                locationManager.getStringAddress { locationCityName in
                    completion(locationCityName)
                }
            } else {
                completion("\(weatherData.address)")
            }
        }
    }
    
    /// Получить дополнительные параметры текущей погоды
    /// - Parameter row: Номер строки параметра
    /// - Returns: Значение дополнительного параметра
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
    
    /// Получить количество дополнительных параметров о текущей погоде
    /// - Returns: Количество параметров
    func getCountParam() -> Int {
        return 6
    }
    
    /// Получить массив почасовых данных
    /// - Parameter day: День, относительно которого получаются почасовые данные
    /// - Returns: Массив данных по часам
    func getHoursStatistics(from day: Days) -> [Hours] {
        return day.hours.filter({!($0.icon?.isEmpty ?? false)})
    }
    
    /// Получить один день
    /// - Parameter index: индекс дня в массиве
    /// - Returns: День
    func getDay(from index: Int = 0) -> Days? {
        if let weatherData = weatherData {
            return weatherData.days[index]
        } else {
            return nil
        }
    }
    
    /// Получить массив дней
    /// - Returns: Массив дней
    func getDays() -> [Days] {
        if let weatherData = weatherData {
            return weatherData.days
        } else {
            return []
        }
    }
    
}
