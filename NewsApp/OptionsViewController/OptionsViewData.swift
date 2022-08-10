//
//  OptionsViewData.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 10/08/2022.
//

import Foundation

final class OptionsViewData {
    
    static var shared = OptionsViewData()
    private init(){}
    
    private var startDate: Date?
    private var endDate: Date?
    private var countryIndex = 0
    private var categoryIndex = 0
    
    func setStartDate(newDate: Date) {
        startDate = newDate
    }
    
    func getStartDate() -> Date? {
        return startDate
    }
    
    func setEndDate(newDate: Date) {
        endDate = newDate
    }
    
    func getEndDate() -> Date? {
        return endDate
    }
    
    func setCountryIndex(newIndex: Int) {
        countryIndex = newIndex
    }
    
    func getCountryIndex() -> Int {
        return countryIndex
    }
    
    func setcategoryIndex(newIndex: Int) {
        categoryIndex = newIndex
    }
    
    func getcategoryIndex() -> Int {
        return categoryIndex
    }
    
}
