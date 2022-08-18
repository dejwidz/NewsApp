//
//  WeatherData.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 14/08/2022.
//

import Foundation

////{
//"latitude":50.34,
//"longitude":18.699999,
//"generationtime_ms":0.9800195693969727,
//"utc_offset_seconds":0,
//"timezone":"GMT",
//"timezone_abbreviation":"GMT",
//"elevation":261.0,
//"hourly_units":{
//   "time":"iso8601",
//   "temperature_2m":"°C",
//   "rain":"mm",
//   "cloudcover":"%",
//   "weathercode":"wmo code"
//},
//"hourly":{
//   "time":[
//      "2022-08-14T00:00",
//      "2022-08-14T01:00",
//
//      "2022-08-20T22:00",
//      "2022-08-20T23:00"
//   ],
//   "temperature_2m":[
//      18.2,
//      18.2,
//
//      18.6,
//      18.3
//   ],
//   "rain":[
//      0.0,
//      0.0,
//
//      0.0,
//      0.0
//   ],
//   "cloudcover":[
//      90.0,
//      100.0,
//      98.0,
//
//      65.0,
//      64.0
//   ],
//   "weathercode":[
//      3.0,
//      3.0,
//
//      2.0,
//      2.0
//   ]
//}
//}

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
