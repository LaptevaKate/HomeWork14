//
//  Observable.swift
//  HomeWork14
//
//  Created by Екатерина Лаптева on 10.05.22.
//

import Foundation


class Observable<T> {
    
    private var listener: ((T) -> ())?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }

    func bind(_ handler: @escaping ((T) -> ())) {
        listener = handler
    }
}
