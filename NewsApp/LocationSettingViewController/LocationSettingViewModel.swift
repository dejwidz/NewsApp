//
//  LocationSettingViewModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 13/08/2022.
//

import Foundation
import CoreLocation

protocol LocationSettingViewModelProtocol: AnyObject {
    var delegate: LocationSettingViewModelDelegate? {get set}
    func getWeatherForLastPosition()
    func setUpNewPosition(newPosition: CLLocation)
}

protocol LocationSettingViewModelDelegate: AnyObject {
    func locationHasBeenSet(_ locationSettingViewModel: LocationSettingViewModelProtocol)}

final class LocationSettingViewModel {
    
    weak var delegate: LocationSettingViewModelDelegate?
    private var model: LocationSettingModelProtocol
    
    init(model: LocationSettingModelProtocol) {
        self.model = model
        model.delegate = self
    }
}

extension LocationSettingViewModel: LocationSettingViewModelProtocol {
    func setUpNewPosition(newPosition: CLLocation) {
        model.setUpNewPosition(newPosition: newPosition)
    }
    
    func getWeatherForLastPosition() {
        delegate?.locationHasBeenSet(self)
    }
}

extension LocationSettingViewModel: LocationSettingModelDelegate {
    func locationHasBeenSet(_ locationSettingModel: LocationSettingModelProtocol) {
        delegate?.locationHasBeenSet(self)
    }
}
