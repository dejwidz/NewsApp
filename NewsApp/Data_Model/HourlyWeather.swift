//
//  HourlyWeather.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/08/2022.
//

import Foundation

struct HourlyWeather {
    let dayName: String?
    let hour: String?
    let temperature: Double?
    let rain: Double?
    let cloudcover: Double?
    let snow: Double?
    let code: Double?
    
    init(dayName: String, hour: String, temperature: Double, rain: Double, cloudcover: Double, snow: Double, code: Double) {
        self.dayName = dayName
        self.hour = hour
        self.temperature = temperature
        self.rain = rain
        self.cloudcover = cloudcover
        self.snow = snow
        self.code = code
    }
}
