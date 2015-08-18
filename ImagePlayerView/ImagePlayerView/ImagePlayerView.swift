//
//  ImagePlayerView.swift
//  ImagePlayerView
//
//  Created by green on 15/8/17.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class ImagePlayerView: UIView {
    
    var images = [UIImage]()                      // 图片数组
    {
        didSet {
            
            reload()
        }
    }
    
    var index : Int = -1   // 当前显示第几张
    {
        willSet{
            
            // 符合条件才切换图片
            if  newValue < imageViews.count
                && newValue >= 0
                && imageViews.count > 0{
                
                switchImage(newValue)
            }
        }
    }
    
    var currentPageIndicatorTintColor = UIColor.magentaColor() {
        
        willSet {
            pageControl.currentPageIndicatorTintColor = newValue
        }
    }
    
    var pageIndicatorTintColor        = UIColor.whiteColor() {
        
        willSet {
            pageControl.pageIndicatorTintColor = newValue
        }
    }
    
    private let kImageView  = "imageView"
    private var imageViews  = [TransformFadeView]()
    private var pageControl : UIPageControl!
    private var pageControlConstraints = [NSLayoutConstraint]()
    
    
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
        
        // 创建pageControl
        pageControl = UIPageControl()
        pageControl.userInteractionEnabled = true
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        self.addSubview(pageControl)
        
        // 约束
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pageControl]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["pageControl":pageControl]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[pageControl]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["pageControl":pageControl]))
    }
    
    // MARK: -
    
    /**
     * 刷新控件
     */
    private func reload() {
        
        // 移除图片视图
        for imageView in imageViews {
            
            imageView.removeFromSuperview()
        }
        
        // 图片字典
        var imageViewDic = [String:TransformFadeView]()
        
        for(var i=0;i<images.count;i++){
            
            // 创建imageViews
            let imageView = TransformFadeView(image: images[i])
            
            // 存放图片视图数组
            imageViews.append(imageView)
            
            // 存放图片视图字典
            imageViewDic["\(kImageView)\(i)"] = imageView
            
            // 代码控制约束必须设置此项
            imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            // 增加图片视图
            self.addSubview(imageView)
            
            // 增加约束
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[\(kImageView)\(i)]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: imageViewDic))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[\(kImageView)\(i)]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: imageViewDic))
            
        }
        
        // 设置pageControl层次
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        self.bringSubviewToFront(pageControl)
    }
    
    /**
     * 切换图片
     * 
     * @param index 图片索引
     */
    private func switchImage(index:Int) {
        
        //获取将要现实的图片View的Z-index
        let currentIndex = (self.subviews as NSArray).indexOfObject(imageViews[index])
        
        // 隐藏上层的View
        for (var i = self.subviews.count - 1;i>currentIndex; i--) {
            
            if let imageView = self.subviews[i] as? TransformFadeView {
                
                if !imageView.isHiding! {
                    
                    imageView.hideAnimated(true)
                }
            }
        }
        
        // 显示下层的View直到显示当前的为止
        for (var i = 0; i<=currentIndex; i++) {
            
            if let imageView = self.subviews[i] as? TransformFadeView {
                
                if imageView.isHiding! {
                    
                    imageView.showAnimated(true)
                }
            }
        }
        
        // 设置pageControl
        pageControl.currentPage = index
        
    }
}