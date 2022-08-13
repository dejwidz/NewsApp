//
//  WeatherViewController.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 13/08/2022.
//

import UIKit
import MapKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    let viewModel = WeatherViewModel(model: WeatherModel())
    let locationManager = CLLocationManager()
    var currentUserLocation: CLLocation?
    
    let currentPositionButton: UIButton = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let button = UIButton()
        button.frame = CGRect(x: w * 0.1, y: h * 0.125, width: w * 0.8, height: h * 0.1)
        button.setTitle("Check weather for current position", for: .normal)
        button.addTarget(self, action: #selector(currentPositionButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = CGFloat(w * 0.01)
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = h * 0.025
        button.titleLabel?.layer.cornerRadius = h * 0.025
        
        return button
    }()
    
    @objc func currentPositionButtonTapped(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("here")

    }
    
    let customPositionButton: UIButton = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let button = UIButton()
        button.frame = CGRect(x: w * 0.1, y: h * 0.26, width: w * 0.8, height: h * 0.1)
        button.setTitle("Check weather for choosen position", for: .normal)
        button.addTarget(self, action: #selector(customPositionButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = CGFloat(w * 0.01)
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = h * 0.025
        button.titleLabel?.layer.cornerRadius = h * 0.025
        
        return button
    }()
    
    @objc func customPositionButtonTapped(_ sender: UIButton) {
        view.addSubview(map)
    }
    
    let map: MKMapView = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let map = MKMapView()
        map.frame = CGRect(x: w * 0.1, y: h * 0.4, width: w * 0.8, height: h * 0.55)
        map.layer.borderWidth = CGFloat(w * 0.01)
        map.layer.borderColor = UIColor.black.cgColor
        map.layer.cornerRadius = h * 0.025
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.black
        title = "Weather"
        viewModel.delegate = self
        locationManager.delegate = self
        view.addSubview(currentPositionButton)
        view.addSubview(customPositionButton)
        view.backgroundColor = UIColor.white
        
    }
    

    
}

extension WeatherViewController: WeatherViewModelDelegate {
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty, currentUserLocation == nil else {
            locationManager.stopUpdatingLocation()
            return
        }
        currentUserLocation = locations.first
        locationManager.stopUpdatingLocation()
        print("\(currentUserLocation)")
        guard let currentUserLocation = currentUserLocation else {return}
        viewModel.setUpNewPosition(newPosition: currentUserLocation)
    }
}
