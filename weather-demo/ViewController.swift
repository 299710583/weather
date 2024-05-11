//
//  ViewController.swift
//  weather-demo
//
//  Created by 曾卫 on 2024/4/29.
//

import UIKit
import SwiftPullToRefresh

class ViewController: UIViewController {
    
    var url: URL?
    var myScrollView: UIScrollView?
    var fullSize: CGSize?
    var weather: String?
    var temp_c: Int?
    var cityName: String?
    var myImageView: UIImageView?
    var weatherLabel: UILabel?
    var cityLabel: UILabel?
    var tempLabel: UILabel?
    var humidityLabel: UILabel?
    var windLabel: UILabel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getWeatherData("dongguan")
//        creatView()
     
    }

}


//
//extension ViewController{
//    
//    
//    func imageForWeather(weatherName: String?) -> UIImage? {
//        guard let weatherName = weatherName else { return nil }
//        
//        var weatherImage: UIImage
//        
//        switch weatherName {
//        case "晴":
//            weatherImage = UIImage(named: "qing")!
//        case "多云","局部多云":
//            weatherImage = UIImage(named: "duoyun")!
//        case "晴间多云":
//            weatherImage = UIImage(named: "qingjianduoyuan")!//这个有问题
//        case "阴", "雾霾":
//            weatherImage = UIImage(named: "yin")!
//        case "小雪", "阵雪","雪":
//            weatherImage = UIImage(named: "xiaoxue")!
//        case "阴转晴":
//            weatherImage = UIImage(named: "yinzhuanqing")!
//        case "小雨","雷区有零星小雨":
//            weatherImage = UIImage(named: "xiaoyu")!
//        case "大雨", "中雨":
//            weatherImage = UIImage(named: "dayu")!
//        case "雨转晴":
//            weatherImage = UIImage(named: "yuzhuanqing")!
//        case "阵雨":
//            weatherImage = UIImage(named: "zhenyu")!
//        case "暴雨":
//            weatherImage = UIImage(named: "baoyu")!
//        case "雨夹雪":
//            weatherImage = UIImage(named: "yujiaxue")!
//        case "冰雹":
//            weatherImage = UIImage(named: "bingbao")!
//        default:
//            weatherImage = UIImage(named: "qing")!
//        }
//        
//        return weatherImage
//    }
//    
//    
//    func creatView(){
//        fullSize = self.view.bounds.size
//        
//        //建立一个可滑动的view
//        myScrollView = UIScrollView()
//        guard let myScrollView = myScrollView else { return }
//        myScrollView.frame = CGRect(x: 0, y: 0, width: fullSize?.width ?? 0, height: fullSize?.height ?? 0)
//        myScrollView.contentSize = CGSize(width: fullSize?.width ?? 0, height: (fullSize?.height ?? 0) * 1.5)
//        myScrollView.showsVerticalScrollIndicator = true
//        myScrollView.indicatorStyle = .black
//        myScrollView.isScrollEnabled = true
//        myScrollView.backgroundColor = .clear
//        
//        let backgroudImage = UIImage(named: "1.jpg")
//        let backgroudImageView = UIImageView(image: backgroudImage)
//        self.view.addSubview(backgroudImageView)
//        
//        //下拉刷新，并且在里边写刷新要执行的是
//        myScrollView.spr_setTextHeader {
//            [weak self] in
//            let label = UILabel()
//            //这里之后要定义一个nextTime，用来记录最近更新时间
//            label.text = "最近更新时间"
//            label.textColor = .black
//            label.textAlignment = .center
//            label.frame = CGRect(x: 0, y: 10, width: 200, height: 20)
//            label.tag = 123
//            label.center = CGPoint(x: (self?.fullSize?.width ?? 0) * 0.5, y: 10)
//            label.font = UIFont.systemFont(ofSize: 14)
//            print(1)
//            self?.myScrollView?.addSubview(label)
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self?.myScrollView?.spr_endRefreshing()
//                // 移除文字标签
//                if let labelToRemove = self?.myScrollView?.viewWithTag(123) {
//                    labelToRemove.removeFromSuperview()
//                }
//            }
//        }
//        self.view.addSubview(myScrollView)
//        
//        let weatherData = WeatherData(city: "wuhan")
//        
//        //位置
//        cityLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
//        guard let cityLabel = cityLabel else { return }
//        cityLabel.text = weatherData.city
//        cityLabel.textColor = .white
//        cityLabel.textAlignment = .center
//        cityLabel.center = CGPoint(x: (fullSize?.width ?? 0) * 0.5, y: (fullSize?.height ?? 0) * 0.1)
//        cityLabel.font = UIFont(name: "Arial", size: 55)
//        
//        myScrollView.addSubview(cityLabel)
//        //图片
//        let image = imageForWeather(weatherName: weatherData.weather)
//        
//        myImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 220, height: 200))
//        guard let myImageView = myImageView else { return }
//        myImageView.center = CGPoint(x: (fullSize?.width ?? 0) * 0.5, y: (fullSize?.height ?? 0) * 0.25)
//        
//        myImageView.image = image
//        myScrollView.addSubview(myImageView)
//        
//        //温度 湿度
//        tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
//        guard let tempLabel = tempLabel else { return }
//        var weatherText = "\(weatherData.temp_c ?? 0)℃"
//        tempLabel.text = weatherText
//        tempLabel.textColor = .white
//        tempLabel.textAlignment = .center
//        tempLabel.center = CGPoint(x: (fullSize?.width ?? 0) * 0.25, y: (fullSize?.height ?? 0) * 0.5)
//        tempLabel.font = UIFont(name: "Arial", size: 60)
//        myScrollView.addSubview(tempLabel)
//        
//        humidityLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
//        guard let humidityLabel = humidityLabel else { return }
//        weatherText = "\(weatherData.humidity ?? 0)RH"
//        humidityLabel.text = weatherText
//        humidityLabel.textColor = .white
//        humidityLabel.textAlignment = .center
//        humidityLabel.center = CGPoint(x: (fullSize?.width ?? 0) * 0.72, y: (fullSize?.height ?? 0) * 0.5)
//        humidityLabel.font = UIFont(name: "Arial", size: 60)
//        myScrollView.addSubview(humidityLabel)
//        
//        
//        
//        //天气描述
//        weatherLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
//        guard let weatherLabel = weatherLabel else { return }
//        weatherText = "\(weatherData.weather ?? "sunny")"
//        weatherLabel.text = weatherText
//        weatherLabel.textColor = .white
//        weatherLabel.textAlignment = .center
//        weatherLabel.center = CGPoint(x: (fullSize?.width ?? 0) * 0.5, y: (fullSize?.height ?? 0) * 0.4)
//        weatherLabel.font = UIFont(name: "Arial", size: 60)
//        myScrollView.addSubview(weatherLabel)
//        
//        //风速,风向
//        windLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
//        guard let windLabel = windLabel else { return }
//        weatherText = "风向\(weatherData.windDirection ?? " ")  风速\(weatherData.windSpeed ?? 0.0)kph"
//        windLabel.text = weatherText
//        windLabel.textColor = .white
//        windLabel.textAlignment = .center
//        windLabel.center = CGPoint(x: (fullSize?.width ?? 0) * 0.5, y: (fullSize?.height ?? 0) * 0.56)
//        windLabel.font = UIFont(name: "Arial", size: 30)
//        myScrollView.addSubview(windLabel)
//        
//        
//        
//    }
//    
//    
//    @objc func refreshData() {
//        // 在这里编写下拉刷新时需要执行的操作
//        
//        // 模拟数据加载
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            // 刷新数据完成后结束刷新状态
//            self.refreshControl.endRefreshing()
//        }
//    }
//    
//    
//    /// 获取天气数据，这里只是简单测试一下能不呢个获取
//    /// - Parameter city: 获取所需城市
//    func getWeatherData(_ city:String){
//        
//        url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=2bedc09032474542ba132358243004&q=\(city)&days=7&aqi=no&alerts=no&lang=zh")!
////        self.url = URL(string: "https://api.weatherapi.com/v1/current.json?key=2bedc09032474542ba132358243004&q=\(city)&aqi=no&alerts=no&lang=zh")
//        guard let url = url else { return }
//        let request = URLRequest(url: url)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request){ [self](data,response,error) in
//            if let error = error {
//                print("Error:\(error.localizedDescription)")
//            }
//            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else{
//                print("Error:Invalid response")
//                return
//            }
//            guard let data = data else{
//                print("Error:Miss data")
//                return
//            }
//            
//            do {
//                let json = try JSONSerialization.jsonObject(with: data,options: []) as! [String:Any]
////                let json = json
//                //取出数据
//                let current = json["current"] as! [String:Any]
//                let condition = current["condition"] as! [String:Any]
//                let text = condition["text"] as! String
//                weather = text
//                print(text)
//                temp_c = current["temp_c"] as? Int
//                print(temp_c ?? 0)
//                print(current["humidity"] as? Int ?? 0)
//            }catch let parseError{
//                print("Error\(parseError.localizedDescription)")
//            }
//        }
//        task.resume()
//    }
//    
//    //添加城市天气
//    //用tag来传递参数
////    @objc func addCityWeather(){
//////        print("添加城市")
////        //跳转添加页面
////        let searchVC = SearchViewController()
////        present(searchVC, animated: true, completion: nil)
////    }
////    
////    //删除城市天气
////    @objc func minusCityWeather(){
////        print("删除当前页面城市")
////    }
//
//
//}
