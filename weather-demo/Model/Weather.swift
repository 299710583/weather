//
//  Weather.swift
//  weather-demo
//
//  Created by 曾卫 on 2024/5/11.
//

import Foundation

class Weather: Codable {
    var city: String?
    var weather: String?
    var temperature: Int?
    var humidity: Int?
    var windDirection: String?
    var windSpeed: Double?
    var cityZh: String?
    var dates: [String]?
    var maxTemps: [Double]?
    var minTemps: [Double]?
    var weathers: [String]?
    
    init(_ city: String, _ cityZh: String) {
        self.city = city
        self.cityZh = cityZh
    }
}
