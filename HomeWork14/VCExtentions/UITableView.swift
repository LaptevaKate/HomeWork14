//
//  UITableView.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 26.05.22.
//

import Foundation
import UIKit


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
            viewController.index = indexPath.row
            navigationController?.pushViewController(viewController, animated: true)
        }
}
    
