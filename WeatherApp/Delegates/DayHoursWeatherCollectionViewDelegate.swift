//
//  DayHoursWeatherCollectionViewDelegate.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 22.07.2021.
//

import UIKit

class DayHoursWeatherCollectionViewDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var weatherViewModel: WeatherViewModelType?
    
    
    init(weatherViewModel: WeatherViewModelType) {
        super.init()
        self.weatherViewModel = weatherViewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let weatherViewModel = weatherViewModel, let day = weatherViewModel.getDay(from: Shared.shared.sharedSelectedDayIndex ?? 0) else {
            return 0
        }
        return weatherViewModel.getHoursStatistics(from: day).count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayWeatherCollectionViewCell.identifier, for: indexPath) as? DayWeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let weatherViewModel = weatherViewModel, let day = weatherViewModel.getDay(from: Shared.shared.sharedSelectedDayIndex ?? 0) {
            cell.setupWith(dayWeather: weatherViewModel.getHoursStatistics(from: day)[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
        return CGSize(width: 170, height: collectionView.frame.size.height)
        
    }
    
}
