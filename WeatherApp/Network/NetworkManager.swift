//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 08.07.2021.
//

import Foundation
class NetworkManager {
    
    private let apiKey = "C8Z97DTMR7Q5A6T966UZK4KWW"
    private let scheme = "https"
    private let host = "weather.visualcrossing.com"
    
    /// Получить погоду с сервера
    /// - Parameters:
    ///   - city: Город, по которому осуществляется запрос о погоде
    ///   - completion: замыкание
    /// - Returns: Данные о погоде
    func getWeather(from city: String, completion: @escaping (WeatherData) -> ()) {
        
        let path = "/VisualCrossingWebServices/rest/services/timeline/\(city)"
        let unitGroupQueryItem = URLQueryItem(name: "unitGroup", value: "metric")
        let keyQueryItem = URLQueryItem(name: "key", value: apiKey)
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [unitGroupQueryItem, keyQueryItem]
        guard let url = urlComponents.url else {
            return
        }
        let myRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: myRequest) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data in response")
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(weatherData)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
}
