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
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var airHumidityLabel: UILabel!
    @IBOutlet weak var gustOfWindLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    //MARK: - Properties
    var forecast: ForecastModel?
    var totalDays = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
