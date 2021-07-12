//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 08.07.2021.
//

import Foundation

struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let resolvedAddress: String
    let address: String
    let timezone: String
    let description: String
    let days: [Days]
    let currentConditions: CurrentConditions
}

struct Days: Codable {
    let datetime: String
    let datetimeEpoch: TimeInterval
    let tempmax: Double
    let tempmin: Double
    let temp: Double
    let feelslike: Double
    let humidity: Double
    let precip: Double
    let precipprob: Double?
    let windspeed: Double
    let pressure: Double
    let visibility: Double
    let uvindex: Int
    let sunrise: String
    let sunriseEpoch: TimeInterval
    let sunset: String
    let sunsetEpoch: TimeInterval
    let conditions: String
    let description: String
    let icon: String
    let hours: [Hours]
}

struct Hours: Codable {
    let datetime: String
    let datetimeEpoch: TimeInterval
    let temp: Double?
    let feelslike: Double?
    let humidity: Double?
    let precip: Double?
    let precipprob: Double?
    let windspeed: Double?
    let pressure: Double?
    let visibility: Double?
    let uvindex: Double?
    let conditions: String?
    let icon: String?
}

struct CurrentConditions: Codable {
    let datetime: String
    let datetimeEpoch: TimeInterval
    let temp: Double
    let feelslike: Double
    let humidity: Double
    let precip: Double?
    let precipprob: Double?
    let preciptype: String?
    let windspeed: Double?
    let pressure: Double?
    let visibility: Double?
    let uvindex: Int?
    let conditions: String
    let icon: String
    let sunrise: String
    let sunriseEpoch: TimeInterval
    let sunset: String?
    let sunsetEpoch: TimeInterval
}
