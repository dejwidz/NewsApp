//
//  WeatherModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/08/2022.
//

import Foundation

protocol WeatherModelProtocol: AnyObject {
    var delegate: WeatherModelDelegate? {get set}
    func getWeatherData()
}

protocol WeatherModelDelegate: AnyObject {
    //    func jakaśTamFunkcja(_ modelName: ModelNameProtocol)
    
}

final class WeatherModel {
    
    weak var delegate: WeatherModelDelegate?
    
    init() {}
    
    var dayName: [String]?
    var hour: [String]?
    var temperature: [Double]?
    var rain: [Double]?
    var cloudcover: [Double]?
    var snow: [Double]?
    var code: [Double]?
    
}

extension WeatherModel: WeatherModelProtocol {
    
    func getWeatherData() {
        print("w pogodzie---------------------------------------------_________------")
        NetworkingServices.shared.getWeather(completion: {[weak self] result in
            switch result {
            case .success(let weather):
                let d = Date.now
                let c = DateFormatter()
                c.dateFormat = "cccc"
                let e: String = c.string(from: d)
                print(e)
                print("sukces")
                print(weather)
                
                self?.hour = weather.hourly?.time
                self?.temperature = weather.hourly?.temperature_2m
                self?.rain = weather.hourly?.rain
                self?.cloudcover = weather.hourly?.cloudcover
                self?.snow = weather.hourly?.snowfall
                self?.code = weather.hourly?.weathercode
                self?.buildHourlyWeatherArray()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}

extension WeatherModel {
    
    func buildHourlyWeatherArray(){
        var weatherArray: [HourlyWeather] = []
        
        
    }
    
    
    
}
