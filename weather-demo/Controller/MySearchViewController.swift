//
//  MYSearchViewController.swift
//  weather-demo
//
//  Created by 曾卫 on 2024/5/6.
//

import UIKit

class MySearchViewController: UIViewController, UISearchBarDelegate {
    var fullSize: CGSize?
    var searchBar: UISearchBar?
    var weatherData: Weather?
    var requestService: RequestService?
    var block: ((Weather?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
}

extension MySearchViewController {
    func createView() {
        view.backgroundColor = .lightGray
        fullSize = self.view.bounds.size
        searchBar = UISearchBar()
        guard let searchBar = searchBar else { return }
        
        searchBar.barTintColor = .lightGray
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "搜索相应的城市"
        //        searchBar.tintColor = .darkGray
        
        searchBar.frame = CGRect(x: 0, y: 10, width: fullSize?.width ?? 0, height: 40)
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        searchBar.becomeFirstResponder()
    }

    // 这个是点击键盘上的确认之后的查询才做
    // 具体需要查询哪个接口的天气
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 新建一个用于错误的弹窗
        let alertController = UIAlertController(title: "提示", message: "你的输入非法，请重新输入", preferredStyle: .alert)
        
        // 添加确认按钮
        let confirmAction = UIAlertAction(title: "确认", style: .default) { _ in
            // 在这里执行清除搜索框操作
            searchBar.text = ""
            searchBar.becomeFirstResponder()
        }
        alertController.addAction(confirmAction)
        
        searchBar.resignFirstResponder()
        guard let cityZh = searchBar.text else { return }
        
        // 查询天气
        let nameChange = NameChange()
        
        guard let cityName = nameChange.dict[cityZh] else { present(alertController, animated: true, completion: nil); return }
        weatherData = RequestService(city: cityName, cityZh: cityZh).weather
        
        // 判断输入是否合法
        // 若有错误弹窗，重新输入
        
        // 创建UIAlertController
        if requestService?.errors != nil {
            // 显示弹窗
            present(alertController, animated: true, completion: nil)
        } else {
            block?(weatherData)
//            delegate?.handleWeatherData(weatherData)
            // 创建UIAlertController
            let alertController = UIAlertController(title: nil, message: "添加成功！", preferredStyle: .alert)
            // 显示弹窗
            present(alertController, animated: true, completion: nil)
            // 过半秒后自动关闭弹窗
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alertController.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        if let cancelButton = ((searchBar.subviews[0]).subviews.compactMap { $0 as? UIButton }).first {
            cancelButton.setTitle("取消", for: .normal)
//             取消按钮的其他样式设置可以在这里进行
            cancelButton.setTitleColor(.blue, for: .normal)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text != nil else {
            return
        }
        searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}
