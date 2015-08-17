//
//  ImagePlayerView.swift
//  ImagePlayerView
//
//  Created by green on 15/8/17.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class ImagePlayerView: UIView {
    
    var imageViews = [TransformFadeView]()                      // 图片数组
    {
        didSet {
            
            reload()
        }
    }
    
    var index : Int = -1   // 当前显示第几张
    {
        willSet{
            
            switchImage(newValue)
        }
    }
    
    private let kImageView = "imageView"
    
    // MARK: -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        self.backgroundColor = UIColor.redColor()
    }
    
    // MARK: -
    
    /**
     * 刷新控件
     */
    private func reload() {
        
        // 图片字典
        var imageViewDic = [String:TransformFadeView]()
        
        for(var i=0;i<imageViews.count;i++){
            
            // 存放图片字典
            imageViewDic["\(kImageView)\(i)"] = imageViews[i]
            
            // 代码控制约束必须设置此项
            imageViews[i].setTranslatesAutoresizingMaskIntoConstraints(false)
            
            // 增加图片视图
            self.addSubview(imageViews[i])
            
            // 增加约束
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[\(kImageView)\(i)]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: imageViewDic))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[\(kImageView)\(i)]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: imageViewDic))
            
            // 设置当前显示页数
            index = i
            
        }
    }
    
    /**
     * 切换图片
     * 
     * @param index 图片索引
     */
    private func switchImage(index:Int) {
        
        if imageViews.count > 0 {
            
            // 调整视图层次
            if index >= imageViews.count {
                
                self.bringSubviewToFront(imageViews[imageViews.count - 1])
            } else if index < 0 {
                
                self.bringSubviewToFront(imageViews[0])
            } else {
                
                self.bringSubviewToFront(imageViews[index])
            }
        }
    
    }
}
