//
//  WeatherTablewViewCellTableViewCell.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/08/2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
  
    var identifier = "weatherCell"
    var weatherData: HourlyWeather?
    
    let dayNameLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 0
        return label
    }()
    
    let hourLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let temperatureLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let rainLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let snowLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let cloudsLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor.white
        image.tintColor = UIColor.black
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.addSubview(dayNameLabel)
        contentView.addSubview(hourLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(rainLabel)
        contentView.addSubview(snowLabel)
        contentView.addSubview(cloudsLabel)
        contentView.addSubview(image)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = contentView.frame.size.width
        let h = contentView.frame.size.height
        dayNameLabel.frame = CGRect(x: w * 0.05, y: h * 0.05, width: w * 0.4, height: h * 0.2)
        hourLabel.frame = CGRect(x: w * 0.05, y: h * 0.3, width: w * 0.4, height: h * 0.15)
        temperatureLabel.frame = CGRect(x: w * 0.05, y: h * 0.45, width: w * 0.4, height: h * 0.15)
        rainLabel.frame = CGRect(x: w * 0.05, y: h * 0.60, width: w * 0.4, height: h * 0.15)
        snowLabel.frame = CGRect(x: w * 0.05, y: h * 0.75, width: w * 0.4, height: h * 0.15)
        cloudsLabel.frame = CGRect(x: w * 0.05, y: h * 0.9, width: w * 0.4, height: h * 0.1)
        image.frame = CGRect(x: w * 0.5, y: h * 0.05, width: w * 0.45, height: h * 0.9)
        setLabelsText()
        setImage()
    }
    
    fileprivate func setDayName() {
        guard let dayName = weatherData?.dayName else {return}
        dayNameLabel.text = dayName
    }
    
    fileprivate func setHour() {
        guard let hour = weatherData?.hour else {return}
        hourLabel.text = hour
    }
    
    fileprivate func setTemperature() {
        guard let temperature = weatherData?.temperature else {return}
        temperatureLabel.text = "Temperature: \(String(describing: temperature)) C"
    }
    
    fileprivate func setRain() {
        guard let rain = weatherData?.rain else {return}
        rainLabel.text = "Rain: \(String(describing: rain)) mm"
    }
    
    fileprivate func setSnow() {
        guard let snow = weatherData?.snow else {return}
        snowLabel.text = "Snow: \(String(describing: snow)) cm"
    }
    
    fileprivate func setClouds() {
        guard let clouds = weatherData?.cloudcover else {return}
        cloudsLabel.text = "Clouds: \(String(describing: clouds)) %"
    }
    
    func setLabelsText() {
        setDayName()
        setHour()
        setTemperature()
        setRain()
        setSnow()
        setClouds()
    }
    
    func getRowHour(hour: String) -> String {
        let hourArray = hour.split(separator: ":")
        return String(hourArray[0])
    }
    
    func setImage() {
        var imageName = ""
        guard let hourString = weatherData?.hour else {return}
        let hour = Int(getRowHour(hour: hourString))
        if hour! > 5 && hour! < 23 {
            imageName = setImageForDay()
        }
        else {
            imageName = setImageForNight()
        }
        
        if imageName == "" {
            imageName = "pause.fill"
        }
        image.image = UIImage(systemName: imageName)
    }
    
    func setImageForDay() -> String {
        guard let code = weatherData?.code,
              let rain = weatherData?.rain,
              let snow = weatherData?.snow,
              let clouds = weatherData?.cloudcover
        else {return ""}
        
        var imageName = ""
        
        if code > 89 {
            imageName = "cloud.bolt.fill"
            if rain > 0 {
                imageName = "cloud.bolt.rain.fill"
            }
        }
        else if code > 39 && code < 50 {
            imageName = "cloud.fog.fill"
        }
        else if snow > 0 {
            imageName = "cloud.snow.fill"
        }
        else if rain > 0 {
            if clouds > 50 {
                imageName = "cloud.heavyrain.fill"
            }
            else {
                imageName = "cloud.sun.rain.fill"
            }
        }
        else if clouds > 75 {
            imageName = "icloud.fill"
        }
        else if clouds > 25 {
            imageName = "cloud.sun.fill"
        }
        else {
            imageName = "sun.max.fill"
        }
        return imageName
    }
    
    /*
     sun.max.fill
     cloud.sun.fill
     icloud.fill
     cloud.heavyrain.fill
     cloud.sun.rain.fill
     cloud.snow.fill
     cloud.bolt.fill
     cloud.bolt.rain.fill
     
     moon.stars.fill
     cloud.moon.fill
     cloud.moon.rain.fill
     
     cloud.hail.fill
     cloud.drizzle.fill
     
     pause.fill
     */
    
    func setImageForNight() -> String {
        guard let code = weatherData?.code,
              let rain = weatherData?.rain,
              let snow = weatherData?.snow,
              let clouds = weatherData?.cloudcover
        else {return ""}
        
        var imageName = ""
        
        if code > 89 {
            imageName = "cloud.bolt.fill"
            if rain > 0 {
                imageName = "cloud.bolt.rain.fill"
            }
        }
        else if code > 39 && code < 50 {
            imageName = "cloud.fog.fill"
        }
        else if snow > 0 {
            imageName = "cloud.snow.fill"
        }
        else if rain > 0 {
            if clouds > 50 {
                imageName = "cloud.moon.rain.fill"
            }
            else {
                imageName = "cloud.moon.rain.fill"
            }
        }
        else if clouds > 75 {
            imageName = "icloud.fill"
        }
        else if clouds > 25 {
            imageName = "cloud.moon.fill"
        }
        else {
            imageName = "moon.stars.fill"
        }
        return imageName
        
    }
}

