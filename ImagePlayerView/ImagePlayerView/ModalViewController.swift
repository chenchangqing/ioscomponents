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
    
    private var transformFadeViews = [TransformFadeView]()      // 图片视图
    
    // MARK: - 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        // 延迟设置图片
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 2)), dispatch_get_main_queue(),{
        
            self.imagePlayerView.index = 0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SETUP
    
    private func setup() {
        
        // 增加图片
        transformFadeViews.append(TransformFadeView(image: UIImage(named: "1")!))
        transformFadeViews.append(TransformFadeView(image: UIImage(named: "2")!))
        
        // 设置图片
        imagePlayerView.imageViews = transformFadeViews
    }

}
