//
//  WeathherModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 13/08/2022.
//

import Foundation
import CoreLocation

protocol WeatherModelProtocol: AnyObject {
    var delegate: WeatherModelDelegate? {get set}
    func getWeatherForCurrentPosition()
    func getWeatherForLastPosition()
    func getWeatherForNewPosition()
    func setUpNewPosition(newPosition: CLLocation)
}

protocol WeatherModelDelegate: AnyObject {
    //    func jakaśTamFunkcja(_ modelName: ModelNameProtocol)
    
}

final class WeatherModel {
    
    weak var delegate: WeatherModelDelegate?
    
    init() {}
    
}

extension WeatherModel: WeatherModelProtocol {
    func setUpNewPosition(newPosition: CLLocation) {
        
    }
    
    func getWeatherForCurrentPosition() {
        
    }
    
    func getWeatherForLastPosition() {
        
    }
    
    func getWeatherForNewPosition() {
        
    }
    
    
}

