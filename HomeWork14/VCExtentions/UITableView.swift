//
//  UITableView.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 26.05.22.
//

import Foundation
import UIKit


extension UITableView {
    public func scrollToTop() {
        DispatchQueue.main.async {
            self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}
    
