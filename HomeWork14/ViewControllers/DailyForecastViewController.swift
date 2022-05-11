//
//  DailyForecastViewController.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 10.05.22.
//

import UIKit

class DailyForecastViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var airHumidityLabel: UILabel!
    @IBOutlet weak var gustOfWindLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    //MARK: - Properties
    var forecast: ForecastModel?
    var index = 0
    var totalDays = 5
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showForecast(for: index)
    }
    
    // MARK: - Methods
    func showForecast(for index: Int) {
        if (index != -1) && (index < totalDays) {
            let dateFormetter = DateFormatter()
            dateFormetter.dateFormat = "yyyy-MM-dd"
            if let date = forecast?.list[index].date {
                    dateFormetter.dateFormat = "MMM d, HH:mm"
                    dateLabel.text = dateFormetter.string(from: date)
            }
            if let pressure = forecast?.list[index].main.pressure {
                let pressureRounded = round(pressure)
                pressureLabel.text = "Pressure: \(Int(pressureRounded)) millibars"
            }
            if let humidity = forecast?.list[index].main.humidity {
                airHumidityLabel.text = "Humidity: \(humidity)%"
            }
            if let gustOfWind = forecast?.list[index].wind.gust {
                gustOfWindLabel.text = "Gust of wind: \(gustOfWind) meter/sec"
            }
        }
    }
   
    // MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
