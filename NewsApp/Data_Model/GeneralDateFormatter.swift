//
//  DateManager.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 01/04/2023.
//

import Foundation

protocol DateManager {
    func dateInFormatYYYYMMdd(forDate: Date) -> String
    func dayName(forDate: Date) -> String
    func rowHour(forDate: Date) -> String
}

final class GeneralDateFormatter: DateManager {
    
    private let dateFormatter = DateFormatter()
    static let shared = GeneralDateFormatter()
    
    private init() {}
    
    func dateInFormatYYYYMMdd(forDate: Date) -> String {
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateString = dateFormatter.string(from: forDate)
        return dateString
    }
    
    func dayName(forDate: Date) -> String {
        dateFormatter.dateFormat = "cccc"
        let dayName = dateFormatter.string(from: forDate)
        return dayName
    }
    
    func rowHour(forDate: Date) -> String {
        dateFormatter.dateFormat = "HH"
        let rowHour = dateFormatter.string(from: forDate)
        return rowHour
    }
}
