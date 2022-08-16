//
//  URLBuilder.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 08/08/2022.
//

import Foundation
import CoreLocation

final class URLBuilder {
    
    static var shared = URLBuilder()
    private init() {}
    
    private let formatter = DateFormatter()
    private var URLHasNotBeenSentToday = true
    private var userIsInterestedInSpecificTopic = false
    
    private let generalURLFirstPart = "https://newsapi.org/v2/everything?"
    private let generalURLQueryMark = "q="
    private var generalURLQuery = "null"
    private let generalURLFromIndicator = "&from="
    private var generalURLDateFrom = "2022-07-10"
    private let generalURLToIndicator = "&to="
    private var generalURLDateTo = "2022-07-11"
    private let generalURLLastPart = "&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683"
    
    private let specificURLFirstPart = "https://newsapi.org/v2/top-headlines?"
    private let specificURLCountryIndicator = "country="
    private var specificURLCountryName = "pl"
    private let specificURLCategoryIndicator = "&category="
    private var specificURLCategoryName = "sports"
    private let specificURLPageSize = "&pageSize=100&"
    private var specificURLLastPart = "apiKey=715dc191ff584bb2b070568ffb2d6683"

    func getURLWithoutQuery() -> URL? {
        return userIsInterestedInSpecificTopic ? getURLWithTopic() : getGeneralURL()
    }
    
    func getGeneralURL() -> URL? {
        if URLHasNotBeenSentToday {
            setGeneralDates()
            URLHasNotBeenSentToday = false
        }
        generalURLQuery = "null"
        let urlString = generalURLFirstPart +
        generalURLQueryMark +
        generalURLQuery +
        generalURLFromIndicator +
        generalURLDateFrom +
        generalURLToIndicator +
        generalURLDateTo +
        generalURLLastPart
        let url = URL(string: urlString)
        return url
    }
    
    func getURLWithTopic() -> URL? {
        let urlString = specificURLFirstPart +
        specificURLCountryIndicator +
        specificURLCountryName +
        specificURLCategoryIndicator +
        specificURLCategoryName +
        specificURLPageSize +
        specificURLLastPart
        let url = URL(string: urlString)
        return url
    }
    
    private func setGeneralDates() {
        let endDate = Date.now
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: endDate)
        formatter.dateFormat = "YYYY-MM-dd"
        generalURLDateFrom = formatter.string(from: startDate!)
        generalURLDateTo = formatter.string(from: endDate)
    }
    
    func setCountry(newCountry: Countries) {
        specificURLCountryName = newCountry.rawValue
    }
    
    func setCategory(newCategory: Categories) {
        specificURLCategoryName = newCategory.rawValue
    }
    
    func setUserIsInterestedInSpecificTopicIndicator(newIndcatorValue: Bool) {
        userIsInterestedInSpecificTopic = newIndcatorValue
    }
    
    func setDateTo(newDateTo: String) {
        generalURLDateTo = newDateTo
    }
    
    func setDateFrom(newDateFrom: String) {
        generalURLDateFrom = newDateFrom
    }
    
    func setQuery(newQuery: String) {
        guard newQuery != "" else {
            generalURLQuery = "null"
            return
        }
        generalURLQuery = newQuery
    }
    
    func getURLWithQuery() -> URL? {
        let urlString = generalURLFirstPart +
        generalURLQueryMark +
        generalURLQuery +
        generalURLFromIndicator +
        generalURLDateFrom +
        generalURLToIndicator +
        generalURLDateTo +
        generalURLLastPart
        let url = URL(string: urlString)
        return url
    }
    
    func getWeatherURL() -> URL? {
        let latitude = DataStorage.shared.getLastLocationLatitude()
        let longitude = DataStorage.shared.getLastLocationLongitude()
//        let urlString =  "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,rain,cloudcover,snowfall,weathercode"
//        let url = URL(string: urlString)
//        return url
        
        let urlString =  "https://api.open-meteo.com/v1/forecast?latitude=" + latitude + "&longitude=" + longitude + "&hourly=temperature_2m,rain,cloudcover,snowfall,weathercode"
        let url = URL(string: urlString)
        return url
        
        
        
        
        
        
    }
    
}
