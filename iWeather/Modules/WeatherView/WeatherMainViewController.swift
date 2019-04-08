//
//  WeatherMainViewController.swift
//  iWeather
//
//  Created by Carlos Daniel Hernandez Chauteco on 3/28/19.
//  Copyright © 2019 chauteco. All rights reserved.
//

import UIKit

class WeatherMainViewController: UIViewController, UITextFieldDelegate{
    
    typealias constants = WeatherMainViewConstants
    typealias serviceKeys = NetworkServiceKeys
    
    let service = NetworkService.shared
    
    @IBOutlet weak var mainPanelWeather: UIView!
    @IBOutlet weak var mainWeatherCityNameLabel: UILabel!
    @IBOutlet weak var mainWeatherTemperatureStatusLabel: UILabel!
    @IBOutlet weak var mainWeatherImageView: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var mainWeatherWindSpeed: UILabel!
    @IBOutlet weak var mainWeatherTimeZone: UILabel!
    @IBOutlet weak var searchWeatherTextField: UITextField!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(endEteringCity), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        getWeather()
        setupUI()
    }
    
    
    private func setupUI(){
        //textfield
        self.searchWeatherTextField.layer.cornerRadius = 10
        self.searchWeatherTextField.textAlignment = .center
        self.searchWeatherTextField.placeholder = constants.TextFieldSearch.placeHolder
        self.searchWeatherTextField.delegate = self
        self.searchWeatherTextField.layer.borderWidth = 1
        self.searchWeatherTextField.layer.borderColor = UIColor.blue.cgColor
        self.searchWeatherTextField.backgroundColor = .clear
        
        //labels persona
        mainWeatherCityNameLabel.adjustsFontSizeToFitWidth = true
        mainWeatherCityNameLabel.textAlignment = .center
        mainWeatherTemperatureStatusLabel.adjustsFontSizeToFitWidth = true
        mainWeatherTemperatureStatusLabel.textAlignment = .center
        //edit view
        self.view.backgroundColor = .black
        //edit panel
        self.mainPanelWeather.layer.cornerRadius = 10
        self.mainPanelWeather.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEteringCity))
        
        view.addGestureRecognizer(tap)
    }
    
    private func getWeather(){
        let parameters = [serviceKeys.city: constants.mainCity]
        service.getWeather(with: parameters, success: {[weak self] (data) in
            let decodeData = try! JSONDecoder().decode(MediumDetailWeather.self, from: data)
            self?.mainWeatherCityNameLabel.text = "Ciudad: " + decodeData.data[decodeData.count - 1].city_name
            self?.mainWeatherWindSpeed.text = "Velocidad Aire: \(decodeData.data[0].wind_spd)"
            self?.mainWeatherTimeZone.text = "Zona Horaria: " + decodeData.data[0].timezone
            
            if (decodeData.data[0].pod == "d"){
                self?.backgroundImage.image = UIImage(named: "day")
            }else{
                self?.backgroundImage.image = UIImage(named: "night")
            }
            self?.mainWeatherTemperatureStatusLabel.text = "Temperatura: \(decodeData.data[decodeData.count - 1].temp)º"
            self?.service.getImageforIcon(iconCode: decodeData.data[decodeData.count - 1].weather.icon, success: {[weak self] (data) in
                guard let image = UIImage(data: data) else { return }
                self?.mainWeatherImageView.image = image
            })
        })
    }
    
    private func getWeather(city: String){
        let parameters = [serviceKeys.city: city]
        service.getWeather(with: parameters, success: {[weak self] (data) in
            let decodeData = try! JSONDecoder().decode(MediumDetailWeather.self, from: data)
            self?.mainWeatherCityNameLabel.text = "Ciudad: " + decodeData.data[decodeData.count - 1].city_name
            self?.mainWeatherWindSpeed.text = "Velocidad Aire: \(decodeData.data[0].wind_spd) m/s"
            self?.mainWeatherTimeZone.text = "Zona Horaria: " + decodeData.data[0].timezone
            
            if (decodeData.data[0].pod == "d"){
                self?.backgroundImage.image = UIImage(named: "day")
            }else{
                self?.backgroundImage.image = UIImage(named: "night")
            }
            self?.mainWeatherTemperatureStatusLabel.text = "Temperatura: \(decodeData.data[decodeData.count - 1].temp)º"
            self?.service.getImageforIcon(iconCode: decodeData.data[decodeData.count - 1].weather.icon, success: {[weak self] (data) in
                guard let image = UIImage(data: data) else { return }
                self?.mainWeatherImageView.image = image
                })
        })
    }
    
    
    @IBAction func cityHasChange(_ sender: UITextField) {
        if let city = sender.text{
            getWeather(city: city)
        }else{
            getWeather()
        }
    }
    
    @objc func endEteringCity(){
        self.view.endEditing(true)
    }
    
}
