//
//  LocationSettingModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 13/08/2022.
//

import Foundation
import CoreLocation


protocol LocationSettingModelProtocol: AnyObject {
    var delegate: LocationSettingModelDelegate? {get set}
    func getWeatherForCurrentPosition()
    func getWeatherForLastPosition()
    func getWeatherForNewPosition(newPosition: CLLocation)
    func setUpNewPosition(newPosition: CLLocation)
}

protocol LocationSettingModelDelegate: AnyObject {
    //    func jakaśTamFunkcja(_ modelName: ModelNameProtocol)
    
}

final class LocationSettingModel {
    
    weak var delegate: LocationSettingModelDelegate?
    private var position: CLLocation?
    
    init() {}
    
}

extension LocationSettingModel: LocationSettingModelProtocol {
    func setUpNewPosition(newPosition: CLLocation) {
        
    }
    
    func getWeatherForCurrentPosition() {
        
    }
    
    func getWeatherForLastPosition() {
        
    }
    
    func getWeatherForNewPosition(newPosition: CLLocation) {
        
    }
    
    
}

