//
//  URLBuilder.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 08/08/2022.
//


import Foundation
import CoreLocation

protocol URLManager {
    func getURL() -> URL?
    func setCountry(newCountry: Countries)
    func setCategory(newCategory: Categories)
    func setUserIsInterestedInSpecificTopicIndicator(newIndicatorValue: Bool)
    func setDateTo(newDateTo: String)
    func setDateFrom(newDateFrom: String)
    func setWeatherIndicator(newWeatherIndicator: Bool)
    func setQuery(newQuery: String)
}

final class URLBuilder: URLManager {
    
    static var shared = URLBuilder()
    private init() {}
    
    private let formatter = GeneralDateFormatter.shared
    private var URLHasNotBeenSentToday = true
    private var userIsInterestedInSpecificTopic = false
    private var userIsInterestedInWeather = false
    
    //    private let generalURLFirstPart = "https://newsapi.org/v2/everything?"
    //    private let generalURLQueryMark = "q="
    //    private var generalURLQuery = "null"
    //    private let generalURLFromIndicator = "&from="
    //    private var generalURLDateFrom = "2022-07-10"
    //    private let generalURLToIndicator = "&to="
    //    private var generalURLDateTo = "2022-07-11"
    //    private let generalURLLastPart = "&sortBy=relevancy&apiKey=d0bc50ba40234c879f866212f122e197"
    //    private let generalURLLastPart = "&sortBy=relevancy&apiKey=715dc191ff584bb2b070568ffb2d6683"
    
    //    private let specificURLFirstPart = "https://newsapi.org/v2/top-headlines?"
    //    private let specificURLCountryIndicator = "country="
    //    private var specificURLCountryName = "pl"
    //    private let specificURLCategoryIndicator = "&category="
    //    private var specificURLCategoryName = "general"
    //    private let specificURLPageSize = "&pageSize=100&"
    //    private var specificURLLastPart = "apiKey=715dc191ff584bb2b070568ffb2d6683"
    
    private let scheme = "https"
    private let host = "funny-moth-pants.cyclic.app"
    private let path = "/articles"
    private var search = ""
    private var country = ""
    private var topic = "general"
    private var dateFrom = "2022-07-10"
    private var dateTo = "2022-07-11"
    //    private let pathWithQuery = "/articles/\(search)"
    
    private var components = URLComponents()
    
    func getURL() -> URL? {
        if userIsInterestedInWeather {
            return getWeatherURL()
        }
        else if  !userIsInterestedInSpecificTopic && search != "" {
            return getURLWithQuery()
        }
        else {
            return userIsInterestedInSpecificTopic ? getURLWithTopic() : getGeneralURL()
        }
    }
    
    private func getGeneralURL() -> URL? {
        if URLHasNotBeenSentToday {
            setGeneralDates()
            URLHasNotBeenSentToday = false
        }
        if topic == "general" {
            search = ""
        }
        else {
            search = topic
        }
        //        let urlString = generalURLFirstPart +
        //        generalURLQueryMark +
        //        generalURLQuery +
        //        generalURLFromIndicator +
        //        generalURLDateFrom +
        //        generalURLToIndicator +
        //        generalURLDateTo +
        //        generalURLLastPart
        //        let url = URL(string: urlString)
        //        let url = URL(string: "https://funny-moth-pants.cyclic.app/articles?fbclid=IwAR3BdLVZxkEV7Jnd3AMveoPHH6CXN_jYC6sdQZSdWnaTDJlrMYl05oBP86g")
        //        return url
        
        components.scheme = scheme
        components.host = host
        components.path = path
//        components.queryItems = [
//            URLQueryItem(name: "fbclid", value: "IwAR3BdLVZxkEV7Jnd3AMveoPHH6CXN_jYC6sdQZSdWnaTDJlrMYl05oBP86g")
//        ]
        
        let url = components.url
        print("TO+ JEST general URL", url)
        return url
    }
    
    private func getURLWithTopic() -> URL? {
        //        let urlString = specificURLFirstPart +
        //        specificURLCountryIndicator +
        //        specificURLCountryName +
        //        specificURLCategoryIndicator +
        //        specificURLCategoryName +
        //        specificURLPageSize +
        //        specificURLLastPart
        //        let url = URL(string: urlString)
        //        return url
        
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "country", value: country),
            URLQueryItem(name: "category", value: topic),
            URLQueryItem(name: "fbclid", value: "IwAR0QWxDsDdttCb8-u1DZapynzNiwqlkGCevlKtQaeYSszOpj2JzuCFMIZE0")
        ]
        
        let url = components.url
        return url
    }
    
    private func setGeneralDates() {
        let endDate = Date.now
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: endDate)
//        formatter.dateFormat = "YYYY-MM-dd"
        dateFrom = formatter.dateInFormatYYYYMMdd(forDate: startDate!)
        dateTo = formatter.dateInFormatYYYYMMdd(forDate: endDate)
    }
    
    func setCountry(newCountry: Countries) {
        country = newCountry.rawValue
    }
    
    func setCategory(newCategory: Categories) {
        topic = newCategory.rawValue
    }
    
    func setUserIsInterestedInSpecificTopicIndicator(newIndicatorValue: Bool) {
        userIsInterestedInSpecificTopic = newIndicatorValue
    }
    
    func setDateTo(newDateTo: String) {
        dateTo = newDateTo
    }
    
    func setDateFrom(newDateFrom: String) {
        dateFrom = newDateFrom
    }
    
    func setWeatherIndicator(newWeatherIndicator: Bool) {
        userIsInterestedInWeather = newWeatherIndicator
    }
    
    
    func setQuery(newQuery: String) {
        guard newQuery != "" else {
            search = "null"
            return
        }
        search = newQuery
    }
    
    private func getURLWithQuery() -> URL? {
        //        let urlString = generalURLFirstPart +
        //        generalURLQueryMark +
        //        generalURLQuery +
        //        generalURLFromIndicator +
        //        generalURLDateFrom +
        //        generalURLToIndicator +
        //        generalURLDateTo +
        //        generalURLLastPart
        //        let url = URL(string: urlString)
        //        return url
        components.scheme = scheme
        components.host = host
//        components.path = "/articles/\(search)"
        components.path = path
//        components.queryItems = [
//            URLQueryItem(name: "fbclid", value: "IwAR0QWxDsDdttCb8-u1DZapynzNiwqlkGCevlKtQaeYSszOpj2JzuCFMIZE0")
//        ]
        components.queryItems = [
        URLQueryItem(name: "q", value: search)
        ]
        
        let url = components.url
        print("TO+ JEST query URL", url)
        return url
    }
    
    private func getWeatherURL() -> URL? {
        let latitude = DataStorage.shared.getLastLocationLatitude()
        let longitude = DataStorage.shared.getLastLocationLongitude()
        //                let urlString =  "https://api.open-meteo.com/v1/forecast?latitude=" +
        //                latitude +
        //                "&longitude=" +
        //                longitude +
        //                "&hourly=temperature_2m,rain,cloudcover,snowfall,weathercode"
        //                var url = URL(string: urlString)
        //                return url
        
        components.scheme = "https"
        components.host = "api.open-meteo.com"
        components.path = "/v1/forecast"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: latitude),
            URLQueryItem(name: "longitude", value: longitude),
            URLQueryItem(name: "hourly", value: "temperature_2m,rain,snowfall,weathercode,cloudcover")
        ]
        
        let url = components.url
        return url
    }
}
