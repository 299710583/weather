//
//  WeatherViewController.swift
//  weather-demo
//
//  Created by 曾卫 on 2024/5/11.
//

import UIKit
import SwiftPullToRefresh
import AAInfographics

//天气页面
class MyWeatherViewController: UIViewController {

    var weatherView = WeatherView()
    var fullSize: CGSize?
    var cityName: String?
    var myImageView = UIImageView(
        frame: CGRect(
          x: 0, y: 0, width: 220, height: 200))
    var weather: String?
    var weatherLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    var cityLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    var tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    var humidityLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    var windLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
    var cityZh: String?
    var weatherData: Weather?
    var requestService: RequestService?
    var nextTime: String?
    var chartView: AAChartView?
    var chartModel: AAChartModel?
    
    init(_ cityName:String, _ cityZh:String){
        super.init(nibName: nil, bundle: nil)
        self.cityName = cityName
        self.cityZh = cityZh
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatView()
        print("nihao")
        
    }
}


extension MyWeatherViewController{
    
   
    func creatView(){
        
        let currentDate = Date()

        let dateFormatter = DateFormatter()
        fullSize = view.bounds.size
        dateFormatter.dateFormat = "HH:mm:ss" // 仅保留时分秒部分
        guard let fullSize = fullSize else { return }
        nextTime = dateFormatter.string(from: currentDate)
        //建立一个可滑动的view
        weatherView.frame = CGRect(x: 0, y: 0, width: fullSize.width, height: fullSize.height)
        weatherView.contentSize = CGSize(width: fullSize.width, height: (fullSize.height) * 1.3)
        
        let backgroudImage = UIImage(named: "1.jpg")
        let backgroudImageView = UIImageView(image: backgroudImage)
        self.view.addSubview(backgroudImageView)
        
        //下拉刷新，并且在里边写刷新要执行的是
        weatherView.spr_setTextHeader {
            [weak self] in
            let label = UILabel()
            //这里之后要定义一个nextTime，用来记录最近更新时间
            label.text = "最近更新时间\(String(describing: self?.nextTime ?? " "))"
            let currentDate = Date()

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss" // 仅保留时分秒部分
            self?.nextTime = dateFormatter.string(from: currentDate)
            
            label.textColor = .black
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 10, width: 200, height: 20)
            label.tag = 123
            label.center = CGPoint(x: (self?.fullSize?.width ?? 0) * 0.5, y: 10)
            label.font = UIFont.systemFont(ofSize: 14)
            
            self?.weatherView.addSubview(label)
            self?.requestService = RequestService(city: self?.cityName ?? " ",cityZh: self?.cityZh ?? " ")
//            self?.requestService?.block
            self?.requestService?.block = {[weak self] data in
                
                guard let `self` = self else { return }
                
                self.weatherData = data
                refresh()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.weatherView.spr_endRefreshing()
                // 移除文字标签
                if let labelToRemove = self?.weatherView.viewWithTag(123) {
                    labelToRemove.removeFromSuperview()
                }
                
            }
        }
        self.view.addSubview(weatherView)
        let nameChange = NameChange()
        cityName = nameChange.dict[cityZh!]
        requestService = RequestService(city: cityName ?? " ",cityZh: cityZh ?? " ")
//        guard var weatherData = weatherData else { return }
        requestService?.block = {[weak self] data in
            
            guard let `self` = self else { return }
            
            weatherData = data
            drawChart()
            insertData()
        }
        //位置
        cityLabel.textColor = .white
        cityLabel.textAlignment = .center
        cityLabel.center = CGPoint(x: (fullSize.width) * 0.5, y: (fullSize.height) * 0.1)
        cityLabel.font = UIFont(name: "Arial", size: 55)
        self.weatherView.addSubview(cityLabel)
        //图片
        myImageView = UIImageView(
            frame: CGRect(
              x: 0, y: 0, width: 220, height: 200))
        myImageView.center = CGPoint(x: (fullSize.width) * 0.5, y: (fullSize.height) * 0.25)
        self.weatherView.addSubview(myImageView)
        
        //温度 湿度
        
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        tempLabel.center = CGPoint(x: (fullSize.width) * 0.25, y: (fullSize.height) * 0.5)
        tempLabel.font = UIFont(name: "Arial", size: 60)
        self.weatherView.addSubview(tempLabel)
        
        humidityLabel.textColor = .white
        humidityLabel.textAlignment = .center
        humidityLabel.center = CGPoint(x: (fullSize.width) * 0.72, y: (fullSize.height) * 0.5)
        humidityLabel.font = UIFont(name: "Arial", size: 60)
        self.weatherView.addSubview(humidityLabel)
        
        //天气描述
        
        weatherLabel.textColor = .white
        weatherLabel.textAlignment = .center
        weatherLabel.center = CGPoint(x: (fullSize.width) * 0.5, y: (fullSize.height) * 0.4)
        weatherLabel.font = UIFont(name: "Arial", size: 60)
        self.weatherView.addSubview(weatherLabel)
        
        //风速,风向
        
//        print(weatherData.windSpeed ?? "dedede")
        windLabel.textColor = .white
        windLabel.textAlignment = .center
        windLabel.center = CGPoint(x: (fullSize.width) * 0.5, y: (fullSize.height) * 0.6)
        windLabel.font = UIFont(name: "Arial", size: 30)
        self.weatherView.addSubview(windLabel)
        
    }
    
    func insertData(){
        cityLabel.text = weatherData?.cityZh
        let image = imageForWeather(weatherName: weatherData?.weather)
        //图片
        myImageView.image = image
        //温度
        var weatherText = "\(weatherData?.temperature ?? 0)℃"
        tempLabel.text = weatherText
        //湿度
        weatherText = "\(weatherData?.humidity ?? 0)RH"
        humidityLabel.text = weatherText
        //天气
        weatherText = "\(weatherData?.weather ?? "sunny")"
        weatherLabel.text = weatherText
        //风向风速
        weatherText = "风向\(weatherData?.windDirection ?? " ")  风速\(weatherData?.windSpeed ?? 0.0) kph"
        windLabel.text = weatherText
        self.weatherView.addSubview(cityLabel)
        self.weatherView.addSubview(myImageView)
        self.weatherView.addSubview(tempLabel)
        self.weatherView.addSubview(humidityLabel)
        self.weatherView.addSubview(weatherLabel)
        self.weatherView.addSubview(windLabel)
    }
    
    func refresh(){
        let newData:[AASeriesElement] = [
            AASeriesElement()
            .data(weatherData?.maxTemps ?? ["4","5"])
            ,
        AASeriesElement()
            .data(weatherData?.minTemps ?? ["1","2"])]
        chartView?.aa_onlyRefreshTheChartDataWithChartModelSeries(newData)
        insertData()
    }
    
    func drawChart(){
        chartView = AAChartView()
        chartView?.frame = CGRect(x: 0, y: 0, width: fullSize?.width ?? 0, height: (fullSize?.height ?? 0) * 0.4)
        chartView?.center = CGPoint(x: (fullSize?.width ?? 0) * 0.5, y: (fullSize?.height ?? 0) * 0.9)
        chartView?.isClearBackgroundColor = true
        guard let chartView = chartView else { return }
        self.weatherView.addSubview(chartView)
        
        //初始化图标模型
        chartModel = AAChartModel()
        guard let chartModel = chartModel else { return }
        //图标类型
        chartModel.chartType(.line)
        //图表标题
        chartModel.title("天气预测")
        chartModel.inverted(false)
        chartModel.yAxisTitle("℃")
//        chartModel.xAxisTitle("日期")
        //浮动提示框
        chartModel.legendEnabled(true)
        chartModel.tooltipEnabled(true)
   
        chartModel.tooltipValueSuffix("℃")
        chartModel.markerRadius(0)
        chartModel.categories(weatherData?.dates ?? [])
        chartModel.colorsTheme(["#fe117c","#ffc069"])
        chartModel.series([
            AASeriesElement()
                .name("最高气温")
                .data(weatherData?.maxTemps ?? ["4","5"])
                .toDic()!,
            AASeriesElement()
                .name("最低气温")
                .data(weatherData?.minTemps ?? ["1","2"])
                .toDic()!])
        
        
        chartView.aa_drawChartWithChartModel(chartModel)
    }
    
    
    func imageForWeather(weatherName: String?) -> UIImage? {
        guard let weatherName = weatherName else { return nil }
        var weatherImage: UIImage
        
        switch weatherName {
        case "晴":
            weatherImage = UIImage(named: "qing")!
        case "多云","局部多云":
            weatherImage = UIImage(named: "duoyun")!
        case "晴间多云":
            weatherImage = UIImage(named: "qingjianduoyuan")!
        case "阴", "雾霾","阴天":
            weatherImage = UIImage(named: "yin")!
        case "小雪", "阵雪":
            weatherImage = UIImage(named: "xiaoxue")!
        case "阴转晴":
            weatherImage = UIImage(named: "yinzhuanqing")!
        case "小雨","雷区有零星小雨":
            weatherImage = UIImage(named: "xiaoyu")!
        case "大雨", "中雨","中雨或大阵雨":
            weatherImage = UIImage(named: "dayu")!
        case "雨转晴":
            weatherImage = UIImage(named: "yuzhuanqing")!
        case "阵雨","小阵雨":
            weatherImage = UIImage(named: "zhenyu")!
        case "暴雨":
            weatherImage = UIImage(named: "baoyu")!
        case "雨夹雪":
            weatherImage = UIImage(named: "yujiaxue")!
        case "冰雹":
            weatherImage = UIImage(named: "bingbao")!
        default:
            weatherImage = UIImage(named: "qing")!
        }
        
        return weatherImage
    }
    

}
