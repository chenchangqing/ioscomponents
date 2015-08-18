//
//  ImagePlayerView.swift
//  ImagePlayerView
//
//  Created by green on 15/8/17.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

/**
 * 协议
 */
protocol ImagePlayerViewDelegate :NSObjectProtocol {
    
    /**
     * 显示多少张图片
     */
    func numberOfItems() -> Int
    
    /**
     * 初始化图片视图时回调
     */
    func imagePlayerView(imagePlayerView:ImagePlayerView, imageView:UIImageView, index:Int)
    
    /**
     * 图片点击事件
     */
    func imagePlayerView(imagePlayerView:ImagePlayerView, didTapAtIndex index:Int)
    
}

enum PlayOrder {
    
    case Desc   // 降序播放
    case Asc    // 升序播放
}

class ImagePlayerView: UIView {
    
    // MARK: - 可配置属性
    
    /**
     * 当前显示images中的第几张
     */
    var index : Int = -1
    {
        willSet{
            
            if imageViews.count == 0 {
                
                return
            }
            
            // 切换图片
            if  newValue < imageViews.count
                && newValue >= 0{
                
                switchImage(newValue)
            } else if newValue < 0 {
                
                switchImage(0)
            } else {
                
                switchImage(imageViews.count - 1)
            }
        }
        
        didSet {
            
            // 比较新值、旧值可以得出应该升序播放还是降序
            if index >= oldValue {
                
                order = .Asc
            } else {
                
                order = .Desc
            }
        }
    }
    
    /**
     * 页码指示器当前点的颜色
     */
    var currentPageIndicatorTintColor = UIColor.magentaColor() {
        
        willSet {
            pageControl.currentPageIndicatorTintColor = newValue
        }
    }
    
    /**
     * 页码指示器的颜色
     */
    var pageIndicatorTintColor        = UIColor.whiteColor() {
        
        willSet {
            pageControl.pageIndicatorTintColor = newValue
        }
    }
    
    /**
     * 轮播时间控制
     */
    var duration: NSTimeInterval = 4
    
    /**
     * 是否自动播放
     */
    var isAutoPlay = true {
        
        willSet {
            
            if newValue {
                
                setupTimer()
            } else {
                
                if timer != nil {
                    
                    timer.invalidate()
                    timer = nil
                }
            }
        }
    }
    
    /**
     * 代理协议
     */
    var delegate: ImagePlayerViewDelegate?
    
    // MARK: -
    
    private let kImageView  = "imageView"
    private var imageViews  = [TransformFadeView]()
    private var pageControl : UIPageControl!
    private var pageControlConstraints = [NSLayoutConstraint]()
    private var timer : NSTimer!
    private var order : PlayOrder = .Asc
    private var leftSwipeGestureRecognizer:UISwipeGestureRecognizer!
    private var rightSwipeGestureRecognizer:UISwipeGestureRecognizer!
    private var singleRecognizer:UITapGestureRecognizer!
    
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
        
        setupPageControl()
        
        // 定时器
        setupTimer()
        
        // 手势
        setupSwipeGesture()
    }
    
    private func setupPageControl() {
        
        // 创建pageControl
        pageControl = UIPageControl()
        pageControl.userInteractionEnabled = true
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        self.addSubview(pageControl)
        
        // pageControl 事件
        pageControl.addTarget(self, action: Selector("handleClickPageControl:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        // 约束
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[pageControl(50)]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["pageControl":pageControl]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[pageControl]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["pageControl":pageControl]))
    }
    
    private func setupTimer() {
        
        if timer == nil {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: Selector("timerEvent"), userInfo: nil, repeats: true)
        }
    }
    
    private func setupSwipeGesture() {
        
        leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        singleRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleSingleTap:"))
        
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        singleRecognizer.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(leftSwipeGestureRecognizer)
        self.addGestureRecognizer(rightSwipeGestureRecognizer)
        self.addGestureRecognizer(singleRecognizer)
    }
    
    // MARK: -
    
    /**
     * 刷新控件
     */
    func reload() {
        
        // 判断
        if delegate == nil {
            
            println("请设置代理")
            return
        }
        
        // 从代理获取图片个数
        let imageCount = delegate!.numberOfItems()
        if imageCount <= 0 {
            
            return
        }
        
        // 移除图片视图
        for imageView in imageViews {
            
            imageView.removeFromSuperview()
        }
        imageViews.removeAll(keepCapacity: false)
        
        // 图片字典
        var imageViewDic = [String:TransformFadeView]()
        
        for(var i=imageCount - 1;i>=0;i--){
            
            // 创建imageViews
            let imageView = TransformFadeView(frame: CGRectZero)
            
            // 调用delegate方法
            delegate!.imagePlayerView(self, imageView: imageView, index: imageCount - 1 - i)
            
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
        pageControl.numberOfPages = imageViews.count
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
        let willShowView = imageViews[imageViews.count - 1 - index]
        let willShowViewIndex = (self.subviews as NSArray).indexOfObject(willShowView)
        
        // 隐藏上层的View
        for (var i = self.subviews.count - 1;i>willShowViewIndex; i--) {
            
            if let imageView = self.subviews[i] as? TransformFadeView {
                
                if !imageView.isHiding! {
                    
                    imageView.hideAnimated(true)
                }
            }
        }
        
        // 显示下层的View直到显示当前的为止
        for (var i = 0; i<=willShowViewIndex; i++) {
            
            if let imageView = self.subviews[i] as? TransformFadeView {
                
                if imageView.isHiding! {
                    
                    imageView.showAnimated(true)
                }
            }
        }
        
        // 设置pageControl
        pageControl.currentPage = index
        
    }
    
    /**
     * 定时轮播
     */
    func timerEvent() {
        
        if index  < 0 {
            
            index = 1
            
            return
        }
        
        if index == 0 {
            
            index += 1
            
            return
        }
        
        if index  > imageViews.count - 1 {
            
            index = imageViews.count - 1
            
            return
        }
        
        if index  == imageViews.count - 1 {
            
            index -= 1
            
            return
        }
        
        if order == .Asc {
            
            index += 1
        } else {
            
            index -= 1
        }
    }
    
    /**
     * 页码指示器事件
     */
    func handleClickPageControl(sender:UIPageControl) {
        
        isAutoPlay = false
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * UInt64(duration))), dispatch_get_main_queue(), { () -> Void in
            
            self.isAutoPlay = true
        })
        
        index = sender.currentPage
    }
    
    /**
     * 左右滑动
     */
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        
        isAutoPlay = false
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * UInt64(duration))), dispatch_get_main_queue(), { () -> Void in
            
            self.isAutoPlay = true
        })
        
        if sender.direction == UISwipeGestureRecognizerDirection.Left {
            
            if index > 0 {
                
                index -= 1
            }
        }
        
        if sender.direction == UISwipeGestureRecognizerDirection.Right {
            
            if index < imageViews.count - 1 {
                
                index += 1
            }
        }
    }
    
    /**
     * 单击手势
     */
    func handleSingleTap(sender:UITapGestureRecognizer) {
        
        if let delegate = delegate {
            
            delegate.imagePlayerView(self, didTapAtIndex: index)
        }
    }
}
