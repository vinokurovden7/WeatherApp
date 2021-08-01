//
//  WeatherViewModelType.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 22.07.2021.
//

import Foundation

protocol WeatherViewModelType {
    
    /// Получить погоду с сервера
    /// - Parameters:
    ///   - city: Город, для которого нужно получить погоду
    ///   - completion: замыкание
    /// - Returns: Полученные данные о погоде
    func getWeather(from city: String?, completion: @escaping (Bool) -> ())
    
    /// Получить скорость ветра
    /// - Returns: Скорость ветра
    func getWindSpeedToday() -> String
    
    /// Получить текущую температуру
    /// - Returns: Словарь температур
    func getTempToday() -> [String:String]
    
    /// Получить изображение для текущей погоды
    /// - Returns: Наименование изображения
    func getImageToday() -> String
    
    /// Получить текстовое описание погоды
    /// - Returns: Описание погоды
    func getConditions() -> String
    
    /// Получить влажность
    /// - Returns: Влажность
    func getHumidity() -> String
    
    /// Получить дальность видимости
    /// - Returns: Дальность видимости
    func getVisisbility() -> String
    
    /// Получить ультрафиолетовый индекс
    /// - Returns: Ультрафиолетовый индекс
    func getUVIndex() -> String
    
    /// Получить название города, относительно которого отображаются данные
    /// - Returns: Наименование города
    func getCity(completion: @escaping (String) -> Void)
    
    /// Получить дополнительные параметры текущей погоды
    /// - Parameter row: Номер строки параметра
    /// - Returns: Значение дополнительного параметра
    func getDopParamWeather(for row: Int) -> String
    
    /// Получить количество дополнительных параметров о текущей погоде
    /// - Returns: Количество параметров
    func getCountParam() -> Int
    
    /// Получить массив почасовых данных
    /// - Parameter day: День, относительно которого получаются почасовые данные
    /// - Returns: Массив данных по часам
    func getHoursStatistics(from day: Days) -> [Hours]
    
    /// Получить один день
    /// - Parameter index: индекс дня в массиве
    /// - Returns: День
    func getDay(from index: Int) -> Days?
    
    /// Получить массив дней
    /// - Returns: Массив дней
    func getDays() -> [Days]
}
