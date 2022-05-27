//
//  ApiManager.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 10.05.22.
//

import Foundation

struct ApiManager {
    
    func fetchForecast(url urlString: String, completion: @escaping(Result<ForecastModel?, Error>) -> ()) {
        if let url = URL(string: urlString) {
            fetchData(url: url, completion: completion)
        }
    }
    
    func fetchData<T: Codable>(url: URL, completion: @escaping(Result<T?, Error>) -> ()) {
        let url = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let weatherData = try decoder.decode(ForecastModel.self, from: data)
                    completion(.success(weatherData as? T))
                } catch {
                    completion(.success(nil))
                }
            }
        }
        task.resume()
    }
}
