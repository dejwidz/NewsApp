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
    
    let lastPositionButton: UIButton = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let button = UIButton()
        button.frame = CGRect(x: w * 0.1, y: h * 0.26, width: w * 0.8, height: h * 0.1)
        button.setTitle("Check weather for last position", for: .normal)
        button.addTarget(self, action: #selector(lastPositionButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = CGFloat(w * 0.01)
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = h * 0.025
        button.titleLabel?.layer.cornerRadius = h * 0.025
        
        return button
    }()
    
    @objc func lastPositionButtonTapped(_ sender: UIButton) {

    }
    
    let customPositionButton: UIButton = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let button = UIButton()
        button.frame = CGRect(x: w * 0.1, y: h * 0.4, width: w * 0.8, height: h * 0.1)
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
    
    let map: MKMapView = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let map = MKMapView()
        map.frame = CGRect(x: w * 0.1, y: -h * 0.2, width: w * 0.8, height: h * 0.1)
        map.layer.borderWidth = CGFloat(w * 0.01)
        map.layer.borderColor = UIColor.black.cgColor
        map.layer.cornerRadius = h * 0.025
        return map
    }()
    
    @objc func customPositionButtonTapped(_ sender: UIButton) {
        sender.isHidden = true
        view.addSubview(map)
        animateMapPosition()
        animateMapFrameSize()
        }
    
    func animateMapPosition() {
        UIView.animate(withDuration: 1.1)
        {
            let h = UIScreen.main.bounds.height
            let w = UIScreen.main.bounds.width
            self.map.frame = CGRect(x: w * 0.1, y: h * 0.4, width: w * 0.8, height: h * 0.1)
        }
    }

    func animateMapFrameSize() {
        UIView.animate(withDuration: 1, delay: 0.8, options: .allowAnimatedContent, animations: {
            let h = UIScreen.main.bounds.height
            let w = UIScreen.main.bounds.width
            self.map.frame = CGRect(x: w * 0.1, y: h * 0.4, width: w * 0.8, height: h * 0.55)
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.black
        title = "Weather"
        viewModel.delegate = self
        locationManager.delegate = self
        view.addSubview(currentPositionButton)
        view.addSubview(lastPositionButton)
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
