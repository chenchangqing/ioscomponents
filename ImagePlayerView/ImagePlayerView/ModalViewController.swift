//
//  ModalViewController.swift
//  ImagePlayerView
//
//  Created by green on 15/8/17.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController, ImagePlayerViewDelegate {

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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SETUP
    
    private func setup() {
        
        images.append(UIImage(named: "1")!)
        images.append(UIImage(named: "2")!)
        images.append(UIImage(named: "3.jpeg")!)
        images.append(UIImage(named: "4.jpeg")!)
        images.append(UIImage(named: "5.jpeg")!)
        
        imagePlayerView.delegate = self
        imagePlayerView.reload()
    }
    
    // MARK: - ImagePlayerViewDelegate
    
    func numberOfItems() -> Int {
        
        return images.count
    }
    
    func imagePlayerView(imagePlayerView: ImagePlayerView, imageView: UIImageView, index: Int) {
        
        imageView.image = images[index]
    }
    
    func imagePlayerView(imagePlayerView: ImagePlayerView, didTapAtIndex index: Int) {
        
        println("didTapAtIndex:\(index)")
    }

}
