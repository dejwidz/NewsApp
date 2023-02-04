//
//  WeatherViewController.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/08/2022.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private let viewModel = WeatherViewModel(model: WeatherModel())
    private var weatherToDisplay: [HourlyWeather] = []
    private var currentHourWithoutMinuts = 0
    
    let weatherTableView: UITableView = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "weatherCell")
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.allowsSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather forecast"
        view.backgroundColor = UIColor.white
        viewModel.delegate = self
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        view.addSubview(weatherTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.GetWeatherData()
    }
    
}

extension WeatherViewController: WeatherViewModelDelegate {
    func currentHourWithoutMinuts(_ weatherViewModel: WeatherViewModelProtocol, currentHourWithoutMinuts: Int) {
        self.currentHourWithoutMinuts = currentHourWithoutMinuts
        let currentHourIndexPath = IndexPath(row: currentHourWithoutMinuts, section: 0)
        weatherTableView.scrollToRow(at: currentHourIndexPath, at: .middle, animated: true)
        
    }
    
    func weatherHasBeenBuilt(_ weatherViewModel: WeatherViewModelProtocol, weather: [HourlyWeather]) {
        weatherToDisplay = weather
        weatherTableView.reloadData()
        viewModel.getCurrentHourWithoutMinuts()
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weatherTableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherTableViewCell
        cell.weatherData = weatherToDisplay[indexPath.row]
        cell.selectionStyle = .none
        
        guard indexPath.row == currentHourWithoutMinuts else {
            return cell
        }
        
        cell.layer.borderWidth = UIScreen.main.bounds.width * 0.01
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.15
    }
}
