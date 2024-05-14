//
//  WeatherView.swift
//  weather-demo
//
//  Created by 曾卫 on 2024/5/11.
//

import UIKit

class WeatherView: UIScrollView {
    var fullSize: CGSize?
    var weatherLabel: UILabel?
    var cityLabel: UILabel?
    var tempLabel: UILabel?
    var humidityLabel: UILabel?
    var windLabel: UILabel?
    
    init() {
        super.init(frame: .zero)
        self.showsVerticalScrollIndicator = true
        self.indicatorStyle = .black
        self.isScrollEnabled = true
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
