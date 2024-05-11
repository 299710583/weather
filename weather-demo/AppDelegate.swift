//
//  AppDelegate.swift
//  weather-demo
//
//  Created by 曾卫 on 2024/4/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var pageVC: NewPageViewController?
    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var plistFileURL: URL?
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        pageVC = NewPageViewController()
        self.window!.rootViewController = pageVC
        self.window!.makeKeyAndVisible()
        plistFileURL = documentsDirectoryURL.appendingPathComponent("data.plist")
        loadArrayFromPlist()
        
        return true
    }
    
    
    func saveArrayToPlist() {
        let datas = pageVC?.datas
//        print("有多少数据\(datas?.count)")
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
//                        print("Loaded array from plist: \(array2D)")
                        // 在这里处理你的二维数组数据
                        pageVC?.datas = datas
                    }
                }
            } catch {
                print("Failed to load array from plist: \(error)")
            }
        }

    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

