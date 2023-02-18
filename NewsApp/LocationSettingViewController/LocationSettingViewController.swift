//
//  LocationSettingViewController.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 13/08/2022.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI

class LocationSettingViewController: UIViewController, MKMapViewDelegate {
    
    private let viewModel = LocationSettingViewModel(model: LocationSettingModel())
    private let locationManager = CLLocationManager()
    private var currentUserLocation: CLLocation?
    private var locationIsNotSet = true
    
    
    private var initialTopAnchor: NSLayoutConstraint?
    private var heightAnchorForFirstAnimation: NSLayoutConstraint?
    private var heightAnchorForSecondAnimation: NSLayoutConstraint?
    
    private let currentPositionButton: UIButton = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let button = UIButton()
        button.setTitle("Check weather for current position", for: .normal)
        button.addTarget(self, action: #selector(currentPositionButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = CustomColors.backColor
        button.layer.borderWidth = CGFloat(w * 0.01)
        button.layer.borderColor = CustomColors.fontColor?.cgColor
        button.setTitleColor(CustomColors.fontColor, for: .normal)
        button.layer.cornerRadius = h * 0.025
        button.titleLabel?.layer.cornerRadius = h * 0.025
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private  func currentPositionButtonTapped(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("here")
    }
    
    private let lastPositionButton: UIButton = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let button = UIButton()
        button.setTitle("Check weather for last position", for: .normal)
        button.addTarget(self, action: #selector(lastPositionButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = CustomColors.backColor
        button.layer.borderWidth = CGFloat(w * 0.01)
        button.layer.borderColor = CustomColors.fontColor?.cgColor
        button.setTitleColor(CustomColors.fontColor, for: .normal)
        button.layer.cornerRadius = h * 0.025
        button.titleLabel?.layer.cornerRadius = h * 0.025
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func lastPositionButtonTapped(_ sender: UIButton) {
        viewModel.getWeatherForLastPosition()
    }
    
    private let customPositionButton: UIButton = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let button = UIButton()
        button.setTitle("Check weather for choosen position", for: .normal)
        button.addTarget(self, action: #selector(customPositionButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = CustomColors.backColor
        button.layer.borderWidth = CGFloat(w * 0.01)
        button.layer.borderColor = CustomColors.fontColor?.cgColor
        button.setTitleColor(CustomColors.fontColor, for: .normal)
        button.layer.cornerRadius = h * 0.025
        button.titleLabel?.layer.cornerRadius = h * 0.025
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let map: MKMapView = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let map = MKMapView()
        map.layer.borderWidth = CGFloat(w * 0.01)
        map.layer.borderColor = UIColor.black.cgColor
        map.layer.cornerRadius = h * 0.025
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    @objc private func customPositionButtonTapped(_ sender: UIButton) {
        sender.isHidden = true
        view.addSubview(map)
        animateMapPosition()
        animateMapFrameSize()
    }
    
    private func animateMapPosition() {
        UIView.animate(withDuration: 1.1)
        {
            let h = UIScreen.main.bounds.height
            
            self.initialTopAnchor?.isActive = false
            NSLayoutConstraint.activate([
                self.map.topAnchor.constraint(equalTo: self.view.topAnchor, constant: h * 0.4),
            ])
            self.heightAnchorForFirstAnimation = self.map.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1)
            self.heightAnchorForFirstAnimation?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateMapFrameSize() {
        UIView.animate(withDuration: 1, delay: 0.9, options: .allowAnimatedContent, animations: {
            self.heightAnchorForFirstAnimation?.isActive = false
            self.heightAnchorForSecondAnimation = self.map.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.55)
            self.heightAnchorForSecondAnimation?.isActive = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = CustomColors.fontColor
        title = "Choose location"
        viewModel.delegate = self
        locationManager.delegate = self
        setupInterface()
        view.backgroundColor = CustomColors.backColor
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressUccured(_:)))
        map.addGestureRecognizer(longPress)
        
        heightAnchorForFirstAnimation = customPositionButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationIsNotSet = true
    }
    
    private func setupInterface() {
        let h = UIScreen.main.bounds.height
        
        view.addSubview(currentPositionButton)
        view.addSubview(lastPositionButton)
        view.addSubview(customPositionButton)
        view.addSubview(map)
        
        NSLayoutConstraint.activate([
            currentPositionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: h * 0.1),
            currentPositionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentPositionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            currentPositionButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            lastPositionButton.topAnchor.constraint(equalTo: currentPositionButton.bottomAnchor, constant: h * 0.05),
            lastPositionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lastPositionButton.widthAnchor.constraint(equalTo: currentPositionButton.widthAnchor),
            lastPositionButton.heightAnchor.constraint(equalTo: currentPositionButton.heightAnchor),
            
            customPositionButton.topAnchor.constraint(equalTo: lastPositionButton.bottomAnchor, constant: h * 0.05),
            customPositionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customPositionButton.widthAnchor.constraint(equalTo: lastPositionButton.widthAnchor),
            customPositionButton.heightAnchor.constraint(equalTo: lastPositionButton.heightAnchor),
            
            map.widthAnchor.constraint(equalTo: customPositionButton.widthAnchor),
            map.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        initialTopAnchor = map.topAnchor.constraint(equalTo: view.topAnchor, constant: -(h * 1.2))
        initialTopAnchor?.isActive = true
    }
    
    @objc private func longPressUccured(_ sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: self.map)
        let coordinates = map.convert(touchPoint, toCoordinateFrom: self.map)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "Here"
        map.addAnnotation(annotation)
        let latitude = coordinates.latitude
        let longitutde = coordinates.longitude
        let weatherLocation = CLLocation(latitude: latitude, longitude: longitutde)
        guard locationIsNotSet else {return}
        locationIsNotSet = false
        viewModel.setUpNewPosition(newPosition: weatherLocation)
    }
}

extension LocationSettingViewController: LocationSettingViewModelDelegate {
    func locationHasBeenSet(_ locationSettingViewModel: LocationSettingViewModelProtocol) {
        let vc = WeatherViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LocationSettingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty, currentUserLocation == nil else {
            locationManager.stopUpdatingLocation()
            return
        }
        currentUserLocation = locations.first
        locationManager.stopUpdatingLocation()
        guard let currentUserLocation = currentUserLocation else {return}
        guard locationIsNotSet else {return}
        locationIsNotSet = false
        viewModel.setUpNewPosition(newPosition: currentUserLocation)
    }
}
