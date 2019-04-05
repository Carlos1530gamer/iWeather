//
//  WeatherMainViewController.swift
//  iWeather
//
//  Created by Carlos Daniel Hernandez Chauteco on 3/28/19.
//  Copyright © 2019 chauteco. All rights reserved.
//

import UIKit

class WeatherMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    typealias constants = WeatherMainViewConstants
    typealias serviceKeys = NetworkServiceKeys
    
    let service = NetworkService.shared
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainPanelWeather: UIView!
    @IBOutlet weak var mainWeatherCityNameLabel: UILabel!
    @IBOutlet weak var mainWeatherTemperatureStatusLabel: UILabel!
    @IBOutlet weak var mainWeatherImageView: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getFirstWeather()
        setupTableView()
        setupUI()
    }
    
    //MARK: - setup functions
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        let nibFile = UINib(nibName: "WeatherTableViewCell", bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: "WeatherMainCell")
    }
    
    private func setupUI(){
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
    }
    
    private func getFirstWeather(){
        let parameters = [serviceKeys.city: constants.mainCity]
        service.getWeather(with: parameters, success: {[weak self] (data) in
            let decodeData = try! JSONDecoder().decode(MediumDetailWeather.self, from: data)
            self?.mainWeatherCityNameLabel.text = decodeData.data[decodeData.count - 1].city_name
            
            if (decodeData.data[0].pod == "d"){
                self?.backgroundImage.image = UIImage(named: "day")
            }else{
                self?.backgroundImage.image = UIImage(named: "night")
            }
            self?.mainWeatherTemperatureStatusLabel.text = "\(decodeData.data[decodeData.count - 1].temp)º"
            self?.service.getImageforIcon(iconCode: decodeData.data[decodeData.count - 1].weather.icon, success: {[weak self] (data) in
                guard let image = UIImage(data: data) else { return }
                self?.mainWeatherImageView.image = image
            }, fauiled: { (error) in
                print(error)
            })
        }) { (error) in
            print("error")
        }
    }
    //MARK: - Protocols for Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherMainCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        cell.cityNameLabel.text = "city Name"
        cell.temLabel.text = "temperatura"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
