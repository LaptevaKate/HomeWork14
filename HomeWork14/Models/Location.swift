//
//  Location.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 27.05.22.
//

import Foundation
import CoreLocation


struct Location {
  let latitude: Double
  let longitude: Double
  
  var location: CLLocation {
    return CLLocation(latitude: latitude, longitude: longitude)
  }
}

