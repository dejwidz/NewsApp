//
//  WeatherViewController.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/08/2022.
//

import UIKit

class WeatherViewController: UIViewController {

    private let viewModel = WeatherViewModel(model: WeatherModel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather forecast"
        view.backgroundColor = UIColor.white
        viewModel.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.GetWeatherData()
    }
    

}

extension WeatherViewController: WeatherViewModelDelegate {

}
