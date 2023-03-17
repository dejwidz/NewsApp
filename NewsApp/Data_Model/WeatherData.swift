//
//  WeatherData.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 14/08/2022.
//

import Foundation


struct Weather: Codable {
    var hourly: Hourly?
}

struct Hourly: Codable {
    var time: [String]?
    var temperature_2m: [Double]?
    var rain: [Double]?
    var cloudcover: [Double]?
    var snowfall: [Double]?
    var weathercode: [Double]?
}
