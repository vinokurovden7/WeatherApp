//
//  TodayParamWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 09.07.2021.
//

import UIKit

class TodayParamWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageSymbol: UIImageView!
    
    static let identifier = "TableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(with param: String, for row: Int) {
        switch row {
            case 0:
                imageSymbol.image = UIImage(systemName: "wind")
            case 1:
                imageSymbol.image = UIImage(systemName: "drop")
            case 2:
                imageSymbol.image = UIImage(systemName: "binoculars")
            case 3:
                imageSymbol.image = UIImage(systemName: "sun.max")
            case 4:
                imageSymbol.image = UIImage(systemName: "sunrise")
            case 5:
                imageSymbol.image = UIImage(systemName: "sunset")
            default:
                return
        }
        label.text = param
    }
    
}
