//
//  MediumDetailWeather.swift
//  iWeather
//
//  Created by Macbook on 3/27/19.
//  Copyright © 2019 chauteco. All rights reserved.
//

import Foundation

struct MediumDetailWeather: Codable {
    var data: [DataWeather]
    var count: Int
}

struct DataWeather: Codable {
    var city_name: String
    var weather: Weather
    var temp: Double
}

struct Weather: Codable {
    var icon: String
    var description: String
}
