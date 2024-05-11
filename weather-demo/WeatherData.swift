//
//  WeatherData.swift
//  weather-demo
//
//  Created by 曾卫 on 2024/5/6.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherData{
    var city: String?
    var url: URL?
    var json: [String:Any]?
    var weather: String?
    var temp_c: Int?
    var humidity: Int?
    var windDirection: String?
    var windSpeed: Double?
    var errors: String?
    var cityZh: String?
    var dates: [String]?
    var maxTemps: [Double]?
    var minTemps: [Double]?
    var weathers: [String]?
    var block: ((WeatherData) -> Void)?
    
    init(city: String?,cityZh:String?) {
        self.cityZh = cityZh
        self.city = city
        getWeatherData(city)
    }

    
}

extension WeatherData{
    func getWeatherData(_ city:String?){
        guard let city = city else { return }
        
        dates = []
        maxTemps = []
        minTemps = []
        weathers = []
        
        url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=2bedc09032474542ba132358243004&q=\(city)&days=7&aqi=no&alerts=no&lang=zh")!
        //        self.url = URL(string: "https://api.weatherapi.com/v1/current.json?key=2bedc09032474542ba132358243004&q=\(city)&aqi=no&alerts=no&lang=zh")
        
        guard let url = url else { return }
        
        //使用alamofire来实现
        
        AF.request(url).response { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value!)
                //取出当前天气
                self.weather = json["current"]["condition"]["text"].string ?? " "

                self.temp_c = json["current"]["temp_c"].int ?? 0
                self.humidity = json["current"]["humidity"].int ?? 0
                self.windDirection = json["current"]["wind_dir"].string ?? " "
                self.windSpeed = json["current"]["wind_kph"].double ?? 0.0
                
                //取出预测天气
                if let array = json["forecast"]["forecastday"].array{

                    for item in array{
                        let element = JSON(item)
                        //取出日期
                        self.dates?.append(element["date"].string ?? "")

                        
                        //取出最高最低气温
                        self.maxTemps?.append(element["day"]["maxtemp_c"].double ?? 0.0)
//                        print(element["day"]["maxtemp_c"].double ?? 0.0)
                        self.minTemps?.append(element["day"]["mintemp_c"].double ?? 0.0)
                        //取出天气
                        self.weathers?.append(element["day"]["condition"]["text"].string ?? " ")
                        
                    }
                }
                self.block?(self)
                
            case .failure(let error):
                self.errors = error.localizedDescription
                print("Error: \(error.localizedDescription)")
                self.block?(self)
            }
        }
        
        
        //不使用alamofire
//        block?(self)
//
//        let request = URLRequest(url: url)
//        let session = URLSession.shared
//        let semaphore = DispatchSemaphore(value: 0)
//        let task = session.dataTask(with: request){ [self](data,response,error) in
//            if let error = error {
//                errors = "Error:\(error.localizedDescription)"
//                print(errors ?? " ")
//                
//            }
//            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
//                errors = "Error:Invalid response"
//                print(errors ?? " ")
//                semaphore.signal()
//                return
//            }
//            guard let data = data else{
//                errors = "Error:Miss data"
//                print(errors ?? " ")
//                semaphore.signal()
//                return
//            }
//            
//            do {
//                self.json = try JSONSerialization.jsonObject(with: data,options: []) as? [String:Any]
//                
//                //当前
//                let current = self.json?["current"] as? [String:Any]
//                //取出天气状态数据
//                let condition = current?["condition"] as? [String:Any]
//                let text = condition?["text"] as? String
//                self.weather = text
//                
//                // 取出温度
//                self.temp_c = current?["temp_c"] as? Int
//                
//                // 取出湿度
//                self.humidity = current?["humidity"] as? Int
//                
//                // 取出风向
//                self.windDirection = current?["wind_dir"] as? String
//                
//                // 取出风速
//                self.windSpeed = current?["wind_kph"] as? Double
//                //                print(self.windSpeed ?? "ddddd")
//                
//                semaphore.signal()
//                
//            }catch let parseError{
//                print("Error\(parseError.localizedDescription)")
//                semaphore.signal()
//            }
//        }
//        task.resume()
//        
//        semaphore.wait()
    }
}
