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
    func weatherHasBeenDownloaded(_ weatherModel: WeatherModelProtocol, weather: Weather)
}

final class WeatherModel: WeatherModelProtocol {
    
    weak var delegate: WeatherModelDelegate?
    
    init() {}
    
    func getWeatherData() {
        NetworkingServices.shared.getDataFromWeb(typename: Weather(), completion: {[weak self] result in
            switch result {
            case .success(let weather):
                self?.delegate?.weatherHasBeenDownloaded(self!, weather: weather)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

