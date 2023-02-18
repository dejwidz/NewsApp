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
    var nowIndicator = false
    
    private let dayNameLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = CustomColors.fontColor
        label.backgroundColor = CustomColors.backColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hourLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColors.fontColor
        label.backgroundColor = CustomColors.backColor
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColors.fontColor
        label.backgroundColor = CustomColors.backColor
        return label
    }()
    
    private let rainLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColors.fontColor
        label.backgroundColor = CustomColors.backColor
        return label
    }()
    
    private let snowLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColors.fontColor
        label.backgroundColor = CustomColors.backColor
        return label
    }()
    
    private let cloudsLabel: UILabel = {
        var label = UILabel()
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = CustomColors.fontColor
        label.backgroundColor = CustomColors.backColor
        return label
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.backgroundColor = CustomColors.backColor
        image.tintColor = CustomColors.fontColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
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
        
        self.contentView.backgroundColor = CustomColors.backColor
        
        let w = contentView.frame.size.width
        let h = contentView.frame.size.height
        
        NSLayoutConstraint.activate([
        
            dayNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            dayNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: w * 0.05),
            dayNameLabel.widthAnchor.constraint(equalToConstant: w * 0.4),
            dayNameLabel.heightAnchor.constraint(equalToConstant: h * 0.15),
            
            hourLabel.topAnchor.constraint(equalTo: dayNameLabel.bottomAnchor),
            hourLabel.leadingAnchor.constraint(equalTo: dayNameLabel.leadingAnchor),
            hourLabel.widthAnchor.constraint(equalTo: dayNameLabel.widthAnchor),
            hourLabel.heightAnchor.constraint(equalTo: dayNameLabel.heightAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: hourLabel.bottomAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: hourLabel.leadingAnchor),
            temperatureLabel.widthAnchor.constraint(equalTo: hourLabel.widthAnchor),
            temperatureLabel.heightAnchor.constraint(equalTo: hourLabel.heightAnchor),
            
            rainLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor),
            rainLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),
            rainLabel.widthAnchor.constraint(equalTo: temperatureLabel.widthAnchor),
            rainLabel.heightAnchor.constraint(equalTo: temperatureLabel.heightAnchor),
            
            snowLabel.topAnchor.constraint(equalTo: rainLabel.bottomAnchor),
            snowLabel.leadingAnchor.constraint(equalTo: rainLabel.leadingAnchor),
            snowLabel.widthAnchor.constraint(equalTo: rainLabel.widthAnchor),
            snowLabel.heightAnchor.constraint(equalTo: rainLabel.heightAnchor),
            
            cloudsLabel.topAnchor.constraint(equalTo: snowLabel.bottomAnchor),
            cloudsLabel.leadingAnchor.constraint(equalTo: snowLabel.leadingAnchor),
            cloudsLabel.widthAnchor.constraint(equalTo: snowLabel.widthAnchor),
            cloudsLabel.heightAnchor.constraint(equalTo: snowLabel.heightAnchor),
            
            image.topAnchor.constraint(equalTo: dayNameLabel.topAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(w * 0.05)),
            image.widthAnchor.constraint(equalToConstant: w * 0.45),
            image.bottomAnchor.constraint(equalTo: cloudsLabel.bottomAnchor)
        ])

        setLabelsText()
        setImage()
    }
    
    private func setDayName() {
        guard let dayName = weatherData?.dayName else {return}
        dayNameLabel.text = dayName
        
        guard nowIndicator else {return}
        dayNameLabel.text = "Now"
    }
    
    private func setHour() {
        guard let hour = weatherData?.hour else {return}
        hourLabel.text = hour
    }
    
    private func setTemperature() {
        guard let temperature = weatherData?.temperature else {return}
        temperatureLabel.text = "Temperature: \(String(describing: temperature)) C"
    }
    
    private func setRain() {
        guard let rain = weatherData?.rain else {return}
        rainLabel.text = "Rain: \(String(describing: rain)) mm"
    }
    
    private func setSnow() {
        guard let snow = weatherData?.snow else {return}
        snowLabel.text = "Snow: \(String(describing: snow)) cm"
    }
    
    private func setClouds() {
        guard let clouds = weatherData?.cloudcover else {return}
        cloudsLabel.text = "Clouds: \(String(describing: clouds)) %"
    }
    
    private func setLabelsText() {
        setDayName()
        setHour()
        setTemperature()
        setRain()
        setSnow()
        setClouds()
    }
    
    private func getRowHour(hour: String) -> String {
        let hourArray = hour.split(separator: ":")
        return String(hourArray[0])
    }
    
    private func setImage() {
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
    
    private func setImageForDay() -> String {
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
    
    private func setImageForNight() -> String {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
        self.nowIndicator = false
    }
}

