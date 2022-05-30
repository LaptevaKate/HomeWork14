//
//  ForecastTableViewCell.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 10.05.22.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setup(with forecasts: ForecastModel?, for rowNumber: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let forecast = forecasts?.list[rowNumber] else {
                self?.degreesLabel.text = "Loading error"
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.dateFormat = "MMM d, HH:mm"
            
            self?.dateLabel.text = dateFormatter.string(from: forecast.date)
            self?.weatherImageView.image = forecast.weather[0].weatherImage
            self?.degreesLabel.text = "\(String(forecast.main.temp))°C"
        }
    }
}
