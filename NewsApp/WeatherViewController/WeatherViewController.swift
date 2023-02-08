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
        let tableView = UITableView()
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "weatherCell")
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.allowsSelection = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather forecast"
        view.backgroundColor = CustomColors.backColor
        viewModel.delegate = self
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        setupWeatherTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.GetWeatherData()
    }
    
    func setupWeatherTableView() {
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherTableView)
        
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
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
        cell.nowIndicator = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherTableView.scrollToRow(at: IndexPath(row: currentHourWithoutMinuts, section: 0), at: .middle, animated: true)
    }
    
    
}
