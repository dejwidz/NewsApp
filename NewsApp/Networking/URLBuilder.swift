//
//  URLBuilder.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 08/08/2022.
//

import Foundation

final class URLBuilder {
    
    static var shared = URLBuilder()
    private init() {}
    
    private let formatter = DateFormatter()
    private var URLHasNotBeenSentToday = true
//    https://newsapi.org/v2/everything?q=null&from=2022-07-10&to=2022-08-06&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683
    
    private var URLFirstPart = "https://newsapi.org/v2/everything?"
    private var queryMark = "q="
    private var query = "null"
    private var fromIndicator = "&from="
    private var dateFrom = "2022-07-10" {
        willSet {
            print(newValue)
        }
    }
    private var toIndicator = "&to="
    private var dateTo = "2022-07-11" {
        willSet {
            print(newValue)
        }
    }
    private var URLLastPart = "&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683"

    private func setGeneralDates() {
        let endDate = Date.now
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: endDate)
        formatter.dateFormat = "YYYY-MM-dd"
        dateFrom = formatter.string(from: startDate!)
        print("datefrom--------------------------\(dateFrom)")

        dateTo = formatter.string(from: endDate)
        print("dateto--------------------------\(dateTo)")

    }
    
    func getGeneralURL() -> URL? {
        if URLHasNotBeenSentToday {
            setGeneralDates()
            
            URLHasNotBeenSentToday = false
        }
        query = "null"
        let urlString = URLFirstPart + queryMark + query + fromIndicator + dateFrom + toIndicator + dateTo + URLLastPart
        
        print(urlString)
//        url = URL(string: "https://newsapi.org/v2/everything?q=null&from=2022-07-16&to=2022-07-17&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683")!
        print(urlString)
        let url = URL(string: urlString)
        
        return url
    }
    
    func setDateTo(newDateTo: String) {
        dateTo = newDateTo
    }
    
    func setDateFrom(newDateFrom: String) {
        dateFrom = newDateFrom
    }
    
    func setQuery(newQuery: String) {
        guard newQuery != "" else {
            query = "null"
            return
        }
        query = newQuery
    }
    
    func getURLWithQuery() -> URL? {
        let urlString = URLFirstPart + queryMark + query + fromIndicator + dateFrom + toIndicator + dateTo + URLLastPart
        
        print(urlString)
//        url = URL(string: "https://newsapi.org/v2/everything?q=null&from=2022-07-16&to=2022-07-17&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683")!
        print(urlString)
        let url = URL(string: urlString)
        
        return url
    }
    
}
