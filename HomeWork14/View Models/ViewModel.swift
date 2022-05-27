//
//  ViewModel.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 10.05.22.
//

import Foundation

class ViewModel {
    
    private let api = ApiManager()
    
    let forecastModel: Box<ForecastModel?> = Box(nil)
    
    func fetchForecast(url: String) {
        api.fetchForecast(url: url) { result in
            switch result {
            case .success(let forecast):
                self.forecastModel.value = forecast
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
