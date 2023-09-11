//
//  DateProvider.swift
//  quick-reminder
//
//  Created by 垣本 桃弥 on 2023/09/11.
//

import Foundation

protocol DateProviderProtocol {
    var now: Date { get }
}

struct DateProvider: DateProviderProtocol {
    var now: Date {
        get {
            return Date()
        }
    }
}
