//
//  ModalViewController.swift
//  ImagePlayerView
//
//  Created by green on 15/8/17.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet weak var imagePlayerView: ImagePlayerView!        // 轮播控件
    
    private var images = [UIImage]()      // 图片视图
    
    // MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        // 测试不支持自动轮播
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 5)), dispatch_get_main_queue(), { () -> Void in
            
            self.imagePlayerView.isAutoPlay = false
        })
        
        // 改变图片
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 7)), dispatch_get_main_queue(), { () -> Void in
            
            self.images.append(UIImage(named: "1")!)
            self.images.append(UIImage(named: "2")!)
            self.imagePlayerView.images = self.images
            self.imagePlayerView.isAutoPlay = true
        })
        
        // 改变图片
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 9)), dispatch_get_main_queue(), { () -> Void in
            
            self.imagePlayerView.index = 9
        })
        
        // 改变图片
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 12)), dispatch_get_main_queue(), { () -> Void in
            
            self.imagePlayerView.index = -4
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SETUP
    
    private func setup() {
        
        // 增加图片
        images.append(UIImage(named: "1")!)
        images.append(UIImage(named: "2")!)
        images.append(UIImage(named: "3.jpeg")!)
        images.append(UIImage(named: "4.jpeg")!)
        images.append(UIImage(named: "5.jpeg")!)
        
        // 设置图片
        imagePlayerView.images = images
    }

}
