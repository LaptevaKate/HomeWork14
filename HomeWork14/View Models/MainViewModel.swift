//
//  ViewModel.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 10.05.22.
//

import Foundation
import CoreLocation

class MainViewModel {
    
    //MARK: - Public Properties
    public let forecastModel: Box<ForecastModel?> = Box(nil)
    public let error: Box<ErrorAlertModel?> = Box(nil)
    
    public let cities: [String] = [
        "Current location", "Paris", "Brussels",
        "Minsk", "London", "Berlin", "Kiev"
    ]
    
    //MARK: - Private Properties
    private let apiManager = ApiManager()
    
    //MARK: - Public Methods
    public func pickCity(number index:Int, location: CLLocation? = nil) {
        getWeatherForecast(forCityNumber: index)
    }
    
    //MARK: - Private Methods
    private func getWeatherForecast(forCityNumber index: Int, location: CLLocation? = nil) {
        let startUrl = "https://api.openweathermap.org/data/2.5/forecast?"
        let apiKey = "&appid=8e1ac1fdc60e8b1ac204040485030196"
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let isCurrentLocation = index == 0
            
            let apiUrl: String
            if  isCurrentLocation {
                guard let location = location else {
                    self?.forecastModel.value = nil
                    let errorModel = ErrorAlertModel(title: "Error", message: "Incapable to get location", retryAction: { [weak self] in
                        self?.getWeatherForecast(forCityNumber: index, location: location)
                    })
                    self?.error.value = errorModel
                    return
                }
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                apiUrl = startUrl + "lat=\(lat)&lon=\(lon)" + apiKey + "&units=metric"
            } else {
                guard let selectedCity = self?.cities[index] else {
                    self?.forecastModel.value = nil
                    let errorModel = ErrorAlertModel(title: "Error", message: "Incapable to get city", retryAction: { [weak self] in
                        self?.getWeatherForecast(forCityNumber: index, location: location)
                    })
                    self?.error.value = errorModel
                    return
                }
                apiUrl = startUrl + "q=\(selectedCity)" + apiKey + "&units=metric"
            }
            self?.weatherRequest(url: apiUrl)
        }
    }
    
    private func weatherRequest(url: String) {
        apiManager.fetchForecast(url: url) { result in
            switch result {
            case .success(let forecast):
                self.forecastModel.value = forecast
            case .failure(let error):
                print(error.localizedDescription)
                
                let errorModel = ErrorAlertModel(title: "Error", message: error.localizedDescription, retryAction: { [weak self] in
                    self?.weatherRequest(url: url)
                })
                self.error.value = errorModel
            }
        }
    }
}
