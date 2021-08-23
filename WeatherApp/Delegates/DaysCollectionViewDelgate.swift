//
//  DaysCollectionViewDelgate.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 22.07.2021.
//

import UIKit

class DaysCollectionViewDelgate: NSObject,
                                 UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {

    private var weatherViewModel: WeatherViewModelType?
    private var dayHoursWeatherCollectionView: UICollectionView?

    init(weatherViewModel: WeatherViewModelType, dayHoursCollectionView: UICollectionView) {
        super.init()
        self.weatherViewModel = weatherViewModel
        self.dayHoursWeatherCollectionView = dayHoursCollectionView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weatherViewModel = weatherViewModel else {
            return 0
        }
        return weatherViewModel.getDays().count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = DaysCollectionViewCell.identifier
        let dequeueReusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let cell = dequeueReusableCell as? DaysCollectionViewCell else {
            return UICollectionViewCell()
        }

        if Shared.shared.sharedSelectedDayIndex == nil {
            let firstIndexPath = IndexPath(row: 0, section: 0)
            collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .top)
            Shared.shared.sharedSelectedDayIndex = 0
        } else {
            let firstIndexPath = IndexPath(row: Shared.shared.sharedSelectedDayIndex ?? 0, section: 0)
            if !(collectionView.cellForItem(at: firstIndexPath)?.isSelected ?? true) {
                collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .top)
            }
        }

        if let weatherViewModel = weatherViewModel {
            cell.setup(from: weatherViewModel.getDays()[indexPath.row])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dayHoursWeatherCollectionView = dayHoursWeatherCollectionView {
            Shared.shared.sharedSelectedDayIndex = indexPath.row
            dayHoursWeatherCollectionView.reloadData()
        }
    }
}
