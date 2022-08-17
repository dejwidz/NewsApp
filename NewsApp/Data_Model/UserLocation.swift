//
//  UserLocation.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 16/08/2022.
//

import Foundation
import RealmSwift
import CoreLocation

 class UserLocation: Object {
    @Persisted var latitude: String?
    @Persisted var longitude: String?
     
     override init() {}
    
    init(location: CLLocation) {
        self.latitude = "\(location.coordinate.latitude)"
        self.longitude = "\(location.coordinate.longitude)"
    }
    
    func setLocation(newLocation: CLLocation) {
        self.latitude = "\(newLocation.coordinate.latitude)"
        self.longitude = "\(newLocation.coordinate.longitude)"
    }
    
    func getLatitude() -> String {
        guard let latitude = latitude else {
            return ""
        }
        return latitude
    }
    
    func getLongitude() -> String {
        guard let longitude = longitude else {
            return ""
        }
        return longitude
    }
    
    
    
}
