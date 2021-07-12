//
//  DaysCollectionViewCell.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 09.07.2021.
//

import UIKit

class DaysCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundContentView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var maxMinTempLabel: UILabel!
    @IBOutlet weak var chanceOfPrecipitationLabel: UILabel!
    @IBOutlet weak var tempPlaceHolderLabel: UILabel!
    @IBOutlet weak var chancePlaceHolderLabel: UILabel!
    
    static let identifier = "DaysCollectionViewCell"
    
    override var isSelected: Bool {
        didSet {
            selectedCell(cellIsSelected: isSelected)
//            if isSelected {
//                self.backgroundContentView.backgroundColor = UIColor(named: "TextColor")
//                dayLabel.textColor = UIColor(named: "BackgroundColor")
//                maxMinTempLabel.textColor = UIColor(named: "BackgroundColor")
//                chanceOfPrecipitationLabel.textColor = UIColor(named: "BackgroundColor")
//                backgroundContentView.layer.borderColor = UIColor(named: "BackgroundColor")?.cgColor
//            } else {
//                self.backgroundContentView.backgroundColor = UIColor(named: "BackgroundCollectionViewCell")
//                dayLabel.textColor = UIColor(named: "TextColor")
//                maxMinTempLabel.textColor = UIColor(named: "TextColor")
//                chanceOfPrecipitationLabel.textColor = UIColor(named: "TextColor")
//                backgroundContentView.layer.borderColor = UIColor(named: "TextColor")?.cgColor
//            }
            
        }
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        return dateFormatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundContentView.layer.cornerRadius = 20
        backgroundContentView.layer.borderWidth = 1
    }
    
    func setup(from day: Days) {
        dayLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: day.datetimeEpoch))
        imageWeather.image = UIImage(named: day.icon)
        maxMinTempLabel.text = "\(day.tempmin)° - \(day.tempmax)°"
        chanceOfPrecipitationLabel.text = "\(day.precipprob ?? 0) %"
    }
    
    func selectedCell(cellIsSelected: Bool) {
        if cellIsSelected {
            self.backgroundContentView.backgroundColor = UIColor(named: "TextColor")
            dayLabel.textColor = UIColor(named: "BackgroundColor")
            maxMinTempLabel.textColor = UIColor(named: "BackgroundColor")
            chanceOfPrecipitationLabel.textColor = UIColor(named: "BackgroundColor")
            backgroundContentView.layer.borderColor = UIColor(named: "BackgroundColor")?.cgColor
            tempPlaceHolderLabel.textColor = .systemOrange
            chancePlaceHolderLabel.textColor = .systemOrange
        } else {
            self.backgroundContentView.backgroundColor = UIColor(named: "BackgroundCollectionViewCell")
            dayLabel.textColor = UIColor(named: "TextColor")
            maxMinTempLabel.textColor = UIColor(named: "TextColor")
            chanceOfPrecipitationLabel.textColor = UIColor(named: "TextColor")
            backgroundContentView.layer.borderColor = UIColor(named: "TextColor")?.cgColor
            tempPlaceHolderLabel.textColor = .black
                chancePlaceHolderLabel.textColor = .black
        }
    }

}
