//
//  MainViC+SearchBar.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 14.08.2021.
//

import UIKit
extension MainViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        cityTableView.reloadData()
        showCityTableView()
        return true
    }

    func searchBarTextDidBeginEditing(_ searchTextBar: UISearchBar) {
        searchTextBar.setShowsCancelButton(true, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            guard let searchingCity = searchBar.text, let cityViewModel = self.cityViewModel else {
                return
            }
            cityViewModel.searchCity(searchString: searchingCity)
            switch cityViewModel.getCityCount() {
            case 1:
                UIView.animate(withDuration: 0.2) {
                    self.cityTableView.frame.size.height = 40
                }
            case 2:
                UIView.animate(withDuration: 0.2) {
                    self.cityTableView.frame.size.height = 80
                }
            case 3:
                UIView.animate(withDuration: 0.2) {
                    self.cityTableView.frame.size.height = 130
                }
            default:
                UIView.animate(withDuration: 0.2) {
                    self.cityTableView.frame.size.height = 175
                }
            }
            self.cityTableView.reloadData()
            self.showCityTableView()
        }
    }

    func searchBarCancelButtonClicked(_ searchTextBar: UISearchBar) {
        self.view.endEditing(true)
        searchTextBar.setShowsCancelButton(false, animated: true)
        hideCityTableView()
    }

    func searchBarSearchButtonClicked(_ searchTextBar: UISearchBar) {
        searchTextBar.setShowsCancelButton(false, animated: true)
        if searchTextBar.text?.isEmpty ?? true {
            view.endEditing(false)
            return
        }
        guard let city = searchTextBar.text else {
            return
        }
        getWeather(from: city)
        searchTextBar.text = ""
        locationButton.setImage(UIImage(systemName: "location"), for: .normal)
        view.endEditing(false)
        hideCityTableView()
    }

}
