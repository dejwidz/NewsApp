//
//  WeatherViewModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/08/2022.
//

import Foundation

protocol WeatherViewModelProtocol: AnyObject {
    var delegate: WeatherViewModelDelegate? {get set}
    func GetWeatherData()
    func getCurrentHourWithoutMinutes()
}

protocol WeatherViewModelDelegate: AnyObject {
    func weatherHasBeenBuilt(_ weatherViewModel: WeatherViewModelProtocol, weather: [WeatherInfo])
    func currentHourWithoutMinutes(_ weatherViewModel: WeatherViewModelProtocol, currentHourWithoutMinutes: Int)
}

final class WeatherViewModel {
    
    weak var delegate: WeatherViewModelDelegate?
    private var dateManager: DateManager?
    private var model: WeatherModelProtocol
    
    init(model: WeatherModelProtocol, dateManager: DateManager) {
        self.model = model
        self.dateManager = dateManager
        model.delegate = self
    }
    
    private var temperature: [Double] = []
    private var rain: [Double] = []
    private var cloudCover: [Double] = []
    private var snow: [Double] = []
    private var code: [Double] = []
}

extension WeatherViewModel: WeatherViewModelProtocol {
    func getCurrentHourWithoutMinutes() {
        guard let hour = dateManager?.rowHour(forDate: Date.now) else { return }
        let hourInt = Int(hour)!
        delegate?.currentHourWithoutMinutes(self, currentHourWithoutMinutes: hourInt)
    }
    
    func GetWeatherData() {
        model.getWeatherData()
    }
}

extension WeatherViewModel: WeatherModelDelegate {
    func weatherHasBeenDownloaded(_ weatherModel: WeatherModelProtocol?, weather: Weather) {
        self.temperature = weather.hourly?.temperature_2m ?? []
        self.rain = weather.hourly?.rain ?? []
        self.cloudCover = weather.hourly?.cloudcover ?? []
        self.snow = weather.hourly?.snowfall ?? []
        self.code = weather.hourly?.weathercode ?? []
        buildHourlyWeatherArray()
    }
}

extension WeatherViewModel {
    
    private func decodingPossibility() -> Bool {
        guard self.temperature.count >= 24 &&
                self.rain.count >= 24 &&
                self.cloudCover.count >= 24 &&
                self.snow.count >= 24 &&
                self.code.count >= 24 else {
            return false
        }
        return true
    }
    
    private func buildHourlyWeatherArray(){
        guard decodingPossibility() else {
            return
        }
        var weatherArray: [WeatherInfo] = []
        buildDailyWeather(weatherArray: &weatherArray, counter: -2)
        delegate?.weatherHasBeenBuilt(self, weather: weatherArray)
    }
    
    private func buildDailyWeather(weatherArray: inout [WeatherInfo], counter: Int) {
        guard decodingPossibility() && counter < 5 else {return}
        for hour in 0...23 {
            let dayname = getDayName(counter: counter)
            let hour = "\(hour):00"
            let temperatureLevel = self.temperature.remove(at: 0)
            let rainLevel = self.rain.remove(at: 0)
            let cloudcoverLevel = self.cloudCover.remove(at: 0)
            let snowLevel = self.snow.remove(at: 0)
            let weatherCode = self.code.remove(at: 0)
            let newHourlyWeather = WeatherInfo(dayName: dayname, hour: hour, temperature: temperatureLevel, rain: rainLevel, cloudcover: cloudcoverLevel, snow: snowLevel, code: weatherCode)
            weatherArray.append(newHourlyWeather)
        }
        buildDailyWeather(weatherArray: &weatherArray, counter: counter + 1)
    }
    
    private func getDayName(counter: Int) -> String {
        var dayName = ""
        switch counter {
        case -2:
            dayName = "Today"
        case -1:
            dayName = "Tomorrow"
        case 0...4:
            let now = Date.now
            let dayToGetNameFor = Calendar.current.date(byAdding: .day, value: counter + 2, to: now)!
            dayName = (dateManager?.dayName(forDate: dayToGetNameFor))!
        default:
            dayName = ""
        }
        return dayName
    }
}
