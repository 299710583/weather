//
//  MyRefreshViewController.swift
//  weather-demo
//
//  Created by 曾卫 on 2024/4/30.
//

import UIKit

class MyRefreshViewController: UIRefreshControl {
    
    private let refreshLabel = UILabel()
    private let arrowImageView = UIImageView(image: UIImage(systemName: "arrow.name"))
    override init() {
        super.init()
        
        refreshLabel.text = "下拉刷新"
        refreshLabel.textColor = UIColor.gray
        refreshLabel.textAlignment = .center
        addSubview(refreshLabel)
        
        arrowImageView.tintColor = UIColor.gray
        addSubview(arrowImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        refreshLabel.frame = CGRect(x: 0, y: 5, width: frame.size.width, height: 50)
        arrowImageView.frame = CGRect(x: frame.size.width/2 - 10, y: 30, width: 20, height: 20)
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        
        refreshLabel.text = "下拉刷新"
        arrowImageView.isHidden = true
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        refreshLabel.text = "正在刷新..."
        arrowImageView.isHidden = false
    }
    
}
