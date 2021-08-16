//
//  CityTableViewDelegate.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 15.08.2021.
//

import UIKit
class CityTableViewDelegate: NSObject,
                             UITableViewDelegate,
                             UITableViewDataSource {

    private var cityViewModel: CityViewModelType?
    private var viewController: MainViewController?

    init(cityViewModel: CityViewModelType, viewController: MainViewController) {
        super.init()
        self.cityViewModel = cityViewModel
        self.viewController = viewController
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cityViewModel = cityViewModel else {
            return 0
        }
        return cityViewModel.getCityCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cityViewModel = cityViewModel else {
            return UITableViewCell()
        }
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(named: "BackgroundCollectionViewCell")
        cell.textLabel?.text = cityViewModel.getCityArray(index: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            if let cityString = cell.textLabel?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let viewController = viewController {
                viewController.citySearchBar.text = cityString
                viewController.getWeather(from: cityString)
                viewController.hideCityTableView()
                viewController.locationButton.setImage(UIImage(systemName: "location"), for: .normal)
            }
        }
    }
}
