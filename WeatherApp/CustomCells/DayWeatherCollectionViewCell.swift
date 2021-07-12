//
//  DayWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 09.07.2021.
//

import UIKit

class DayWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeDayWeatherLabel: UILabel!
    @IBOutlet weak var iconDayWeather: UIImageView!
    @IBOutlet weak var averageTempDayWeatherLabel: UILabel!
    @IBOutlet weak var chanceOfPrecipitationDayWeatherLabel: UILabel!
    @IBOutlet weak var mainContentView: UIView!
    
    static let identifier = "DayWeatherCollectionViewCell"
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainContentView.layer.cornerRadius = 20
        mainContentView.layer.borderWidth = 1
        mainContentView.layer.borderColor = UIColor(named: "TextColor")?.cgColor
    }
    
    func setupWith(dayWeather: Hours) {
        timeDayWeatherLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: dayWeather.datetimeEpoch))
        if let imageName = dayWeather.icon {
            iconDayWeather.image = UIImage(named: imageName)
        }
        if let temp = dayWeather.temp {
            averageTempDayWeatherLabel.text = "\(temp)°"
        }
        if let precipprob = dayWeather.precipprob {
            chanceOfPrecipitationDayWeatherLabel.text = "\(precipprob)%"
        }
    }

}
