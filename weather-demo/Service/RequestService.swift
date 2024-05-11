//
//  RequestService.swift
//  weather-demo
//
//  Created by 曾卫 on 2024/5/11.
//

import Foundation
import Alamofire
import SwiftyJSON
class RequestService{
    var weather: Weather?
    var url: URL?
    var json: [String:Any]?
    var errors: String?
    var block: ((Weather) -> Void)?
    
    init(city: String,cityZh:String) {
        weather = Weather(city, cityZh)
        getWeatherData(city)
    }
    
    func getWeatherData(_ city:String?){
        guard let city = city else { return }
        
        var dates = [String]()
        var maxTemps = [Double]()
        var minTemps = [Double]()
        var weathers = [String]()
        
        url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=2bedc09032474542ba132358243004&q=\(city)&days=7&aqi=no&alerts=no&lang=zh")!
        guard let url = url else { return }
        
        AF.request(url).response { [self] response in
            switch response.result{
            case .success(let value):
                let json = JSON(value!)
                //取出当前天气
                self.weather?.weather = json["current"]["condition"]["text"].string ?? " "

                self.weather?.temperature = json["current"]["temp_c"].int ?? 0
                self.weather?.humidity = json["current"]["humidity"].int ?? 0
                self.weather?.windDirection = json["current"]["wind_dir"].string ?? " "
                self.weather?.windSpeed = json["current"]["wind_kph"].double ?? 0.0
                
                //取出预测天气
                guard let array = json["forecast"]["forecastday"].array else{ return }
                for item in array{
                    let element = JSON(item)
                    //取出日期
                    dates.append(element["date"].string ?? "")
                    //取出最高最低气温
                    maxTemps.append(element["day"]["maxtemp_c"].double ?? 0.0)
//                        print(element["day"]["maxtemp_c"].double ?? 0.0)
                    minTemps.append(element["day"]["mintemp_c"].double ?? 0.0)
                    //取出天气
                    weathers.append(element["day"]["condition"]["text"].string ?? " ")
                    
                }
                self.weather?.dates = dates
                self.weather?.maxTemps = maxTemps
                self.weather?.minTemps = minTemps
                self.weather?.weathers = weathers
                self.block?(self.weather!)
                
            case .failure(let error):
                self.errors = error.localizedDescription
                print("Error: \(error.localizedDescription)")
                self.block?(self.weather!)
            }
        }
    }
}
