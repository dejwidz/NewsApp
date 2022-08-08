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
    
    let formatter = DateFormatter()
    
    
    var URLFirstPart = "https://newsapi.org/v2/everything?"
    var queryMark = "q="
    var query = "null"
    var fromIndicator = "&from="
    var dateFrom = "2022-07-10"
    var toIndicator = "&to="
    var dateTo = "2022-07-10"
    var URLLastPart = "&sortBy=popularity&apiKey=715dc191ff584bb2b070568ffb2d6683"

    func setGeneralDates() {
        let endDate = Date.now
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)
        formatter.dateFormat = "YYYY-MM-dd"
        dateFrom = formatter.string(from: startDate!)
        dateTo = formatter.string(from: endDate)
    }
    
    func getGeneralURL() -> URL {
        setGeneralDates()
        query = "null"
        guard var url = URL(string: URLFirstPart) else {return URL(string: "")!}
        url.appendPathComponent(queryMark)
        url.appendPathComponent(query)
        url.appendPathComponent(fromIndicator)
        url.appendPathComponent(dateFrom)
        url.appendPathComponent(toIndicator)
        url.appendPathComponent(dateTo)
        url.appendPathComponent(URLLastPart)
        return url
    }
    
    func setDateTo(newDateTo: Date) {
        formatter.dateFormat = "YYYY-MM-dd"
        dateTo = formatter.string(from: newDateTo)
    }
    
    func setDateFrom(newDateFrom: Date) {
        formatter.dateFormat = "YYYY-MM-dd"
        dateFrom = formatter.string(from: newDateFrom)
    }
    
    func setQuery(newQuery: String) {
        guard newQuery != "" else {
            query = "null"
            return
        }
        query = newQuery
    }
    
    func getURLWithQuery() -> URL? {
        guard var url = URL(string: URLFirstPart) else {return nil}
        url.appendPathComponent(queryMark)
        url.appendPathComponent(query)
        url.appendPathComponent(fromIndicator)
        url.appendPathComponent(dateFrom)
        url.appendPathComponent(toIndicator)
        url.appendPathComponent(dateTo)
        url.appendPathComponent(URLLastPart)
        return url
    }
    
}
