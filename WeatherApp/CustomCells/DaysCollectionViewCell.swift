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
        }
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        return dateFormatter
    }
    
    var checkedDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMDD"
        return dateFormatter
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundContentView.layer.cornerRadius = 20
        backgroundContentView.layer.borderWidth = 1
    }
    
    func setup(from day: Days) {
        if checkedDateFormatter.string(from: Date()) == checkedDateFormatter.string(from: Date(timeIntervalSince1970: day.datetimeEpoch)) {
            dayLabel.text = "Сегодня"
        } else {
            dayLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: day.datetimeEpoch))
        }
        imageWeather.image = UIImage(named: day.icon)
        maxMinTempLabel.text = "\(Int(day.tempmin))° - \(Int(day.tempmax))°"
        chanceOfPrecipitationLabel.text = "\(Int(day.precipprob ?? 0)) %"
    }
    
    func selectedCell(cellIsSelected: Bool) {
        if cellIsSelected {
            self.backgroundContentView.backgroundColor = UIColor(named: "TextColor")
            dayLabel.textColor = .systemOrange
            maxMinTempLabel.textColor = .systemOrange
            chanceOfPrecipitationLabel.textColor = .systemOrange
            backgroundContentView.layer.borderColor = UIColor(named: "BackgroundColor")?.cgColor
            tempPlaceHolderLabel.textColor = UIColor(named: "BackgroundColor")
            chancePlaceHolderLabel.textColor = UIColor(named: "BackgroundColor")
        } else {
            self.backgroundContentView.backgroundColor = UIColor(named: "BackgroundCollectionViewCell")
            dayLabel.textColor = .black
            maxMinTempLabel.textColor = .black
            chanceOfPrecipitationLabel.textColor = .black
            backgroundContentView.layer.borderColor = UIColor(named: "TextColor")?.cgColor
            tempPlaceHolderLabel.textColor = UIColor(named: "TextColor")
            chancePlaceHolderLabel.textColor = UIColor(named: "TextColor")
        }
    }

}
