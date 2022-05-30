//
//  ErrorAlertModel.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 30.05.22.
//

import Foundation

struct ErrorAlertModel {
    let title: String
    let message: String
    
    let retryAction: (() -> ())?
    
}
