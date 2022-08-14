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
}

protocol WeatherViewModelDelegate: AnyObject {
    //  func jakaśTamFunkcja(_ viewModelName: ViewModelNameProtocol)
}

final class WeatherViewModel {
    
    weak var delegate: WeatherViewModelDelegate?
    private var model: WeatherModelProtocol
    
    init(model: WeatherModelProtocol) {
        self.model = model
        model.delegate = self
    }
    
}

extension WeatherViewModel: WeatherViewModelProtocol {
    func GetWeatherData() {
        model.getWeatherData()
    }
    
    
}

extension WeatherViewModel: WeatherModelDelegate {
    
}
