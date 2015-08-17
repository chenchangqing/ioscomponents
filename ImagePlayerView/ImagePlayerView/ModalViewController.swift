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
    
    private var timer : NSTimer!
    
    // MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
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
        
        // 设置定时器
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("timerEvent"), userInfo: nil, repeats: true)
    }
    
    func timerEvent() {
        
        imagePlayerView.index = Int(arc4random() % 4)
    }

}
