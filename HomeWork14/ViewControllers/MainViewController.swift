//
//  ViewController.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 7.05.22.
//

import UIKit
import CoreLocation
import SwiftyJSON

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
        let selectedRow = selectCountryPickerView.selectedRow(inComponent: 0)
        if selectedRow != 0 {
            selectedCity = cities[selectedRow]
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


// MARK: - Extension CLLocationManager

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            tableView.reloadData()
        }
    }
}

