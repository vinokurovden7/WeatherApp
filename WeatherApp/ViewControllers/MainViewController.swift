//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 08.07.2021.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    //MARK: IBOutlest
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var fellsLikeLabel: UILabel!
    @IBOutlet weak var dopParamWeatherTableView: UITableView!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var dayHoursWeatherCollectionView: UICollectionView!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationButton: UIButton!

    //MARK: Variables
    private var weatherViewModel: WeatherViewModelType?
    private var selectedDayIndex: Int?
    private let tapScrollViewGesture = UITapGestureRecognizer()
    private let locationMagaer = LocationManager()
    private var daysCollectionViewDelgate: DaysCollectionViewDelgate?
    private var dayHoursWeatherCollectionViewDelegate: DayHoursWeatherCollectionViewDelegate?

    //MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        firstSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let weatherViewModel = weatherViewModel {
            daysCollectionViewDelgate = DaysCollectionViewDelgate(weatherViewModel: weatherViewModel, dayHoursWeatherCollectionView: dayHoursWeatherCollectionView)
            dayHoursWeatherCollectionViewDelegate = DayHoursWeatherCollectionViewDelegate(weatherViewModel: weatherViewModel)
        }

        dayHoursWeatherCollectionView.delegate = dayHoursWeatherCollectionViewDelegate
        dayHoursWeatherCollectionView.dataSource = dayHoursWeatherCollectionViewDelegate
        daysCollectionView.delegate = daysCollectionViewDelgate
        daysCollectionView.dataSource = daysCollectionViewDelgate
        daysCollectionView.allowsMultipleSelection = false

        if cityLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            getWeather(from: nil)
        } else {
            getWeather(from: cityLabel.text)
        }
    }

    //MARK: IBActions:
    @IBAction func locationButtonAction(_ sender: UIButton) {
        locationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        getWeather(from: nil)
    }

    //MARK: Custom func
    fileprivate func firstSetup() {
        hideAllElements()
        NotificationCenter.default.addObserver(self, selector: #selector(locationManagerChangeAutorizationStatus), name: .locationNotification, object: nil)

        tapScrollViewGesture.numberOfTapsRequired = 1
        tapScrollViewGesture.numberOfTouchesRequired = 1
        tapScrollViewGesture.addTarget(self, action: #selector(touchOnScrollView(_:)))

        citySearchBar.delegate = self

        weatherViewModel = WeatherViewModel()

        let daysCollectionViewNib = UINib(nibName: String(describing: DaysCollectionViewCell.self), bundle: nil)
        daysCollectionView.register(daysCollectionViewNib, forCellWithReuseIdentifier: DaysCollectionViewCell.identifier)

        let collectionViewNib = UINib(nibName: String(describing: DayWeatherCollectionViewCell.self), bundle: nil)
        dayHoursWeatherCollectionView.register(collectionViewNib, forCellWithReuseIdentifier: DayWeatherCollectionViewCell.identifier)

        let tableViewNib = UINib(nibName: String(describing: TodayParamWeatherTableViewCell.self), bundle: nil)
        dopParamWeatherTableView.register(tableViewNib, forCellReuseIdentifier: TodayParamWeatherTableViewCell.identifier)
        dopParamWeatherTableView.delegate = self
        dopParamWeatherTableView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    private func getWeather(from city: String?) {
        activityIndicator.startAnimating()
        guard let weatherViewModel = weatherViewModel else {
            return
        }
        weatherViewModel.getWeather(from: city) { isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    self.imageWeather.image = UIImage(named: weatherViewModel.getImageToday())
                    self.temperatureLabel.text = weatherViewModel.getTempToday()["temp"]
                    self.fellsLikeLabel.text = weatherViewModel.getTempToday()["feelslike"]
                    self.cityLabel.text = "\(NSLocalizedString("definingACity", comment: ""))..."
                    weatherViewModel.getCity(completion: { cityName in
                        self.cityLabel.text = cityName
                    })
                    self.conditionsLabel.text = weatherViewModel.getConditions()
                    self.selectedDayIndex = nil
                    self.activityIndicator.stopAnimating()
                    self.dopParamWeatherTableView.reloadData()
                    self.dayHoursWeatherCollectionView.reloadData()
                    self.daysCollectionView.reloadData()
                }
                self.showAllElements()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }

    private func showAllElements() {
        DispatchQueue.main.async {
            self.cityLabel.isHidden = false
            self.imageWeather.isHidden = false
            self.temperatureLabel.isHidden = false
            self.conditionsLabel.isHidden = false
            self.fellsLikeLabel.isHidden = false
            self.dopParamWeatherTableView.isHidden = false
            self.dayHoursWeatherCollectionView.isHidden = false
            self.daysCollectionView.isHidden = false
        }
    }

    private func hideAllElements() {
        DispatchQueue.main.async {
            self.cityLabel.isHidden = true
            self.imageWeather.isHidden = true
            self.temperatureLabel.isHidden = true
            self.conditionsLabel.isHidden = true
            self.fellsLikeLabel.isHidden = true
            self.dopParamWeatherTableView.isHidden = true
            self.dayHoursWeatherCollectionView.isHidden = true
            self.daysCollectionView.isHidden = true
        }
    }

    //MARK: OBJC func
    @objc private func touchOnScrollView(_ sneder: UITapGestureRecognizer) {
        self.view.endEditing(false)
    }

    @objc private func handleShowKeyboard(_ notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let inset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
            mainScrollView.contentInset = inset
        }
    }

    @objc private func handleHideKeyboard(_ notification: Notification) {
        mainScrollView.contentInset = .zero
    }

    @objc private func locationManagerChangeAutorizationStatus(_ notification: Notification) {
        if let userInfo = notification.userInfo, let authorizationStatus = userInfo["authorizationStatus"] as? CLAuthorizationStatus {
            switch authorizationStatus {
                case .denied, .notDetermined, .restricted:
                    hideAllElements()
                    return
                default:
                    showAllElements()
                    getWeather(from: nil)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weatherViewModel = weatherViewModel else {
            return 0
        }
        
        return weatherViewModel.getCountParam()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodayParamWeatherTableViewCell.identifier) as? TodayParamWeatherTableViewCell else {
            return UITableViewCell()
        }
        if let weatherViewModel = weatherViewModel {
            cell.setup(with: weatherViewModel.getDopParamWeather(for: indexPath.row), for: indexPath.row)
        }

        return cell
    }
    
}

extension MainViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchTextBar: UISearchBar) {
        searchTextBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchTextBar: UISearchBar) {
        self.view.endEditing(true)
        searchTextBar.setShowsCancelButton(false, animated: true)
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
    }

}
