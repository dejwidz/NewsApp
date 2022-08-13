//
//  WeatherViewModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 13/08/2022.
//

import Foundation
import CoreLocation

protocol WeatherViewModelProtocol: AnyObject {
    var delegate: WeatherViewModelDelegate? {get set}
    func getWeatherForCurrentPosition()
    func getWeatherForLastPosition()
    func getWeatherForNewPosition()
    func setUpNewPosition(newPosition: CLLocation)

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
    func setUpNewPosition(newPosition: CLLocation) {
        model.setUpNewPosition(newPosition: newPosition)
    }
    
    func getWeatherForCurrentPosition() {
        model.getWeatherForCurrentPosition()
    }
    
    func getWeatherForLastPosition() {
        model.getWeatherForLastPosition()
    }
    
    func getWeatherForNewPosition() {
        model.getWeatherForNewPosition()
    }
    
    
}

extension WeatherViewModel: WeatherModelDelegate {
    
}
