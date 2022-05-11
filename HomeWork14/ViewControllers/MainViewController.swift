//
//  ViewController.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 7.05.22.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var chooseCountryLabel: UILabel!
    @IBOutlet weak var selectCountryPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blueEffect: UIVisualEffectView!
    
    // MARK: - Private properties
    var cities: [String] = [
        "Current location", "Paris", "Brussels",
        "Minsk", "London", "Berlin", "Kiev"]
    
    var countOfDays = 5
    var apiURL: String = ""
    var selectedCity: String = ""
    var viewModel = ViewModel()
    var currentLocation = CLLocation()
    
    let startUrl = "https://api.openweathermap.org/data/2.5/forecast?"
    let apiKey = "&appid=8e1ac1fdc60e8b1ac204040485030196"
    
    let locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        blueEffect.alpha = 0.8
        navigationController?.navigationBar.isHidden = true
       
        selectCountryPickerView.delegate = self
        selectCountryPickerView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.startAnimating()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        currentLocation = locationManager.location ?? CLLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
       getWeatherForecast()
    }
    
    // MARK: - Methods
    func getWeatherForecast() {
        if selectCountryPickerView.selectedRow(inComponent: 0) != 0 {
            selectedCity = cities[selectCountryPickerView.selectedRow(inComponent: 0)]
            apiURL = startUrl + "q=\(selectedCity)" + apiKey + "&units=metric"
          
        } else if selectCountryPickerView.selectedRow(inComponent: 0) == 0 {
            let lat = currentLocation.coordinate.latitude
            let lon = currentLocation.coordinate.longitude
            apiURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)" +
                apiKey + "&units=metric"
        }
        weatherRequest()
    }
    
    func weatherRequest() {
        viewModel.forecastModel.bind { [weak self] forecast in
            DispatchQueue.main.async {
                if forecast != nil {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.tableView.reloadData()
                    self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                } else {
                    self?.activityIndicator.startAnimating()
                    self?.activityIndicator.isHidden = false
                }
            }
        }
        viewModel.fetchForecast(url: apiURL)
    }
}

// MARK: - Extension UIPickerViewDelegate, UIPickerViewDataSource

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(cities[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getWeatherForecast()
    }
}

// MARK: - Extension CLLocationManager

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            tableView.reloadData()
        }
    }
}

// MARK: - Extension UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let count = viewModel.forecastModel.value?.list.count else {
                return 0
            }
            return count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let nameCell = String(describing: ForecastTableViewCell.self)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: nameCell,for: indexPath) as? ForecastTableViewCell else {
                return UITableViewCell()
            }

            DispatchQueue.main.async {
                let forecasts = self.viewModel.forecastModel.value
                if let image = forecasts?.list[indexPath.row].weather[0].weatherImage {
                    cell.weatherImageView.image = image
                }
                if let degrees = forecasts?.list[indexPath.row].main.temp {
                    cell.degreesLabel.text = "\(String(degrees))°C"
                }
                let dateFormetter = DateFormatter()
                dateFormetter.dateFormat = "yyyy-MM-dd"
                if let date = forecasts?.list[indexPath.row].date {
                        dateFormetter.dateFormat = "MMM d, HH:mm"
                        cell.dateLabel.text = dateFormetter.string(from: date)
                }
            }
            return cell
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nameController = String(describing: DailyForecastViewController.self)
            let viewController = storyboard.instantiateViewController(identifier: nameController) as DailyForecastViewController
            
            viewController.modalPresentationStyle = .fullScreen
            viewController.forecast = viewModel.forecastModel.value
//            viewController.index = indexPath.row
            viewController.totalDays = countOfDays
            navigationController?.pushViewController(viewController, animated: true)
        }
}
    
    

