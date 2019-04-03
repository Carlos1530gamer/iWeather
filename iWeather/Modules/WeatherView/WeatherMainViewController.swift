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
    }
    
    private func setupUI(){
        //labels persona
        mainWeatherCityNameLabel.adjustsFontSizeToFitWidth = true
        mainWeatherCityNameLabel.textAlignment = .center
        mainWeatherTemperatureStatusLabel.adjustsFontSizeToFitWidth = true
        mainWeatherTemperatureStatusLabel.textAlignment = .center
    }
    
    private func getFirstWeather(){
        let parameters = [serviceKeys.city: constants.mainCity]
        service.getWeather(with: parameters, success: {[weak self] (data) in
            let decodeData = try! JSONDecoder().decode(MediumDetailWeather.self, from: data)
            self?.mainWeatherCityNameLabel.text = decodeData.data[decodeData.count - 1].city_name
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
