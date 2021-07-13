//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 08.07.2021.
//

import UIKit

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
    
    //MARK: Variables
    private var weatherViewModel: WeatherViewModel?
    private var selectedDayIndex: Int?
    private let tapScrollViewGesture = UITapGestureRecognizer()
    
    //MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        firstSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let cityName = cityLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            print(cityName)
            getWeather(from: cityName)
        }
    }
    
    //MARK: Custom func
    fileprivate func firstSetup() {
        tapScrollViewGesture.numberOfTapsRequired = 1
        tapScrollViewGesture.numberOfTouchesRequired = 1
        tapScrollViewGesture.addTarget(self, action: #selector(touchOnScrollView(_:)))
        //        mainScrollView.addGestureRecognizer(tapScrollViewGesture)
        
        citySearchBar.delegate = self
        
        daysCollectionView.delegate = self
        daysCollectionView.dataSource = self
        let daysCollectionViewNib = UINib(nibName: String(describing: DaysCollectionViewCell.self), bundle: nil)
        daysCollectionView.register(daysCollectionViewNib, forCellWithReuseIdentifier: DaysCollectionViewCell.identifier)
        
        dayHoursWeatherCollectionView.delegate = self
        dayHoursWeatherCollectionView.dataSource = self
        let collectionViewNib = UINib(nibName: String(describing: DayWeatherCollectionViewCell.self), bundle: nil)
        dayHoursWeatherCollectionView.register(collectionViewNib, forCellWithReuseIdentifier: DayWeatherCollectionViewCell.identifier)
        
        let tableViewNib = UINib(nibName: String(describing: TodayParamWeatherTableViewCell.self), bundle: nil)
        dopParamWeatherTableView.register(tableViewNib, forCellReuseIdentifier: TodayParamWeatherTableViewCell.identifier)
        dopParamWeatherTableView.delegate = self
        dopParamWeatherTableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        weatherViewModel = WeatherViewModel()
        getWeather()
    }
    
    private func getWeather(from city: String = "Нижняя Тура") {
        guard let weatherViewModel = weatherViewModel else {
            return
        }
        weatherViewModel.getWeather(from: city) {
            DispatchQueue.main.async {
                self.imageWeather.image = UIImage(named: weatherViewModel.getImageToday())
                self.temperatureLabel.text = weatherViewModel.getTempToday()["temp"]
                self.fellsLikeLabel.text = weatherViewModel.getTempToday()["feelslike"]
                self.cityLabel.text = weatherViewModel.getCity()
                self.conditionsLabel.text = weatherViewModel.getConditions()
                self.selectedDayIndex = nil
                self.activityIndicator.stopAnimating()
                self.dopParamWeatherTableView.reloadData()
                self.dayHoursWeatherCollectionView.reloadData()
                self.daysCollectionView.reloadData()
            }
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
        view.endEditing(false)
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dayHoursWeatherCollectionView {
            guard let weatherViewModel = weatherViewModel, let day = weatherViewModel.getDay(from: selectedDayIndex ?? 0) else {
                return 0
            }
            return weatherViewModel.getHoursStatistics(from: day).count
        } else {
            guard let weatherViewModel = weatherViewModel else {
                return 0
            }
            return weatherViewModel.getDays().count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dayHoursWeatherCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayWeatherCollectionViewCell.identifier, for: indexPath) as? DayWeatherCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let weatherViewModel = weatherViewModel, let day = weatherViewModel.getDay(from: selectedDayIndex ?? 0) {
                cell.setupWith(dayWeather: weatherViewModel.getHoursStatistics(from: day)[indexPath.row])
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DaysCollectionViewCell.identifier, for: indexPath) as? DaysCollectionViewCell else {
                return UICollectionViewCell()
            }
            if selectedDayIndex == nil {
                let firstIndexPath = IndexPath(row: 0, section: 0)
                collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: .top)
                selectedDayIndex = 0
            }
            
            cell.selectedCell(cellIsSelected: indexPath.row == selectedDayIndex)
            
            if let weatherViewModel = weatherViewModel {
                cell.setup(from: weatherViewModel.getDays()[indexPath.row])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
        if collectionView == dayHoursWeatherCollectionView {
            return CGSize(width: daysCollectionView.frame.width - 15, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == daysCollectionView {
            self.selectedDayIndex = indexPath.row
            dayHoursWeatherCollectionView.reloadData()
        }
    }
    
}
