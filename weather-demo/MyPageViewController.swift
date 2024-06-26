//
//  MyUIPageViewController.swift
//  weather-demo
//
//  Created by 曾卫 on 2024/5/7.
//

import UIKit

class MyPageViewController: UIPageViewController {
    var fullSize: CGSize?
    var pages = [UIViewController]()
    var pageControl = UIPageControl()
    var targetNum = 0
    var currentPage = 0
    let userDefault = UserDefaults.standard
    var datas = [[String]]()
    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var plistFileURL: URL?
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        plistFileURL = documentsDirectoryURL.appendingPathComponent("data.plist")
        loadArrayFromPlist()
        // 下次打开先判断缓存是不是为空
        if datas.count == 0 {
            // 创建并添加页面视图控制器
            let semaphor = DispatchSemaphore(value: 1)
            
            let page = WeatherViewController("wuhan", "武汉")
            
            pages.append(page)
            
            datas.append(["wuhan", "武汉"])
        } else {
            for data in datas {
                let page = WeatherViewController(data[0], data[1])
                pages.append(page)
            }
        }

        // 设置初始页面
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        // 添加UIPageControl
        pageControl = UIPageControl()
        pageControl.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50)
        initializePage()
        
        // 添加按钮到UIPageViewController的view上
        addButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveArrayToPlist()
    }
}

extension MyPageViewController {
    func initializePage() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = currentPage
        setViewControllers([pages[currentPage]], direction: .forward, animated: true, completion: nil)
        view.addSubview(pageControl)
    }
    
    func addButton() {
        fullSize = self.view.bounds.size
        
        // 添加和删除按钮
        let addButton = UIButton(type: .custom)
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        addButton.frame = CGRect(x: (self.fullSize?.width ?? 0) - 100, y: (self.fullSize?.height ?? 0) - 100, width: 100, height: 100)
        addButton.addTarget(self, action: #selector(addCityWeather), for: .touchUpInside)
        
        let minusButton = UIButton(type: .custom)
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.black, for: .normal)
        minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 70)
        minusButton.frame = CGRect(x: 0, y: ( self.fullSize?.height ?? 0) - 100, width: 100, height: 100)
        minusButton.addTarget(self, action: #selector(minusCityWeather), for: .touchUpInside)
        
        self.view.addSubview(addButton)
        self.view.addSubview(minusButton)
    }
    
    // 添加城市
    @objc func addCityWeather() {
        // 跳转添加页面
        let searchVC = SearchViewController()

        searchVC.block = { [weak self] data in
            guard let `self` = self else { return }
            let weatherViewController = WeatherViewController((data?.city)!, (data?.cityZh)!)

            self.pages.append(weatherViewController)
            self.currentPage = self.pages.count - 1
            self.initializePage()
            datas.append([(data?.city)!, (data?.cityZh)!])
            saveArrayToPlist()
        }
        present(searchVC, animated: true, completion: nil)
    }

    // 删除城市天气
    @objc func minusCityWeather() {
        self.currentPage = self.pageControl.currentPage
        
        // 判断页面数量
        guard self.pages.count > 1 else { return }
        // 删除当前页面
        self.pages.remove(at: self.currentPage)
        self.datas.remove(at: self.currentPage)
        saveArrayToPlist()
        if self.currentPage >= self.pages.count {
            self.currentPage = self.pages.count - 1
        }
        
        self.initializePage()
    }
    
    func saveArrayToPlist() {
        print("有多少数据\(datas.count)")
        do {
            let data = try PropertyListEncoder().encode(datas)
            try data.write(to: plistFileURL!, options: .atomic)
        } catch {
            print("Failed to save array to plist: \(error)")
        }
    }
    func loadArrayFromPlist() {
        do {
            if let data = try? Data(contentsOf: plistFileURL!) {
                if let datas = try? PropertyListDecoder().decode([[String]].self, from: data) {
                    self.datas = datas
                }
            }
        } catch {
            print("Failed to load array from plist: \(error)")
        }
    }
}

extension MyPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        
        return pages[currentIndex + 1]
    }
}

extension MyPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = viewControllers?.first, let currentIndex = pages.firstIndex(of: currentViewController) {
                pageControl.currentPage = currentIndex
            }
        }
    }
}

extension MyPageViewController: SearchViewControllerDelegate {
    func handleWeatherData(_ weatherData: WeatherData?) {
        let weatherViewController = WeatherViewController((weatherData?.city)!, (weatherData?.cityZh)!)
//            targetNum += 1
        self.pages.append(weatherViewController)
    }
}
