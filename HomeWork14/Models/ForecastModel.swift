//
//  ForecastModel.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 10.05.22.
//

import Foundation
import UIKit

    struct ForecastModel: Codable {
        let list: [List]
}

    struct List: Codable {
        let date: Date
        let main: Main
        let weather: [Weather]
        let wind: Wind
    
        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case main
            case weather
            case wind
        }
    }

    struct Wind: Codable {
        let gust: Double
    }

    struct Weather: Codable {
        let description: String
        let icon: String
        let id: Int

        var weatherImage: UIImage {
            switch id {
            case 200...232:
                return UIImage(systemName: "cloud.bolt.rain.fill")!
            case 300...321:
                return UIImage(systemName: "cloud.drizzle.fill")!
            case 500...531:
                return UIImage(systemName: "cloud.rain.fill")!
            case 600...622:
                return UIImage(systemName: "cloud.snow.fill")!
            case 701...781:
                return UIImage(systemName: "sun.dust")!
            case 800:
                return UIImage(systemName: "sun.max.fill")!
            case 801...804:
                return UIImage(systemName: "cloud.fill")!
            default:
                return UIImage(systemName: "cloud.sun.fill")!
            }
        }
    }

    struct Main: Codable {
        let temp: Double
        let pressure: Double
        let humidity: Double
    }
