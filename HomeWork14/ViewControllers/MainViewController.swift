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
    @IBOutlet weak var selectCountryPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    // MARK: - Private properties
    
    var viewModel = MainViewModel()
    let locationManager = CLLocationManager()
    var location = CLLocation()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinds()
        setUpUi()
        setUpDelegates()
        setUpLocation()
    }
    
    // MARK: - Private Methods
    private func setUpBinds() {
        viewModel.forecastModel.bind { [weak self] newWeather in
            guard newWeather != nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                self?.tableView.scrollToTop()
            }
        }
        viewModel.error.bind { [weak self] error in
            guard let error = error else { return }
            self?.processError(error)
        }
    }
    
    
    private func setUpUi() {
        blurEffect.alpha = 0.8
        navigationController?.navigationBar.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func setUpDelegates() {
        selectCountryPickerView.delegate = self
        selectCountryPickerView.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        location = locationManager.location ?? CLLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
        viewModel.pickCity(number: 0, location: location)
    }
    
    private func processError(_ error: ErrorAlertModel) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            
            if let retryHandler = error.retryAction {
                let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                    retryHandler()
                }
                alert.addAction(retryAction)
            }
            self?.present(alert, animated: true)
        }
    }
}


// MARK: - Extensions

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        viewModel.pickCity(number: 0, location: location)
        DispatchQueue.main.async { [weak self] in
            guard self?.selectCountryPickerView.selectedRow(inComponent: 0) == 0 else { return }
            self?.activityIndicator.startAnimating()
        }
    }
}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(viewModel.cities[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.pickCity(number: row, location: location)
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.forecastModel.value?.list.count ?? 0
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
        viewController.index = indexPath.row
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nameCell = String(describing: ForecastTableViewCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: nameCell,for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(with: self.viewModel.forecastModel.value, for: indexPath.row)
        return cell
    }
}


