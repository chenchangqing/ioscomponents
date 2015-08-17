//
//  TransformFadeView.swift
//  ImagePlayerView
//
//  Created by green on 15/8/17.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class TransformFadeView: UIImageView {
    
    var verticalCount   : Int = 1               // 渐变方块垂直方向个数
    var horizontalCount : Int = 12              // 渐变方块水平方向个数
    var duration        : NSTimeInterval = 1    // 渐变动画的时间
    
    private var maskLayer       : CALayer!      // maskLayer遮罩
    private var submaskLayers   = [CALayer]()   // maskLayer中的子layer
    
    private let kOpacityAnimationShow = "opacityAnimationShow"
    private let kOpacityAnimationHide = "opacityAnimationHide"
    
    // MARK: -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - SETUP
    
    private func setup() {
        
        // 创建maskView
        maskLayer                   = CALayer()
        maskLayer.frame             = self.bounds
        
        // 设置maskLayer
        self.layer.mask = maskLayer
        
        // 计算每个子maskLayer的尺寸
        let height:CGFloat      = CGRectGetHeight(self.bounds)
        let width:CGFloat       = CGRectGetWidth(self.bounds)
        let subHeight:CGFloat   = verticalCount <= 1 ? height : (height / CGFloat(self.verticalCount))
        let subWidth:CGFloat    = horizontalCount <= 1 ? width : (width / CGFloat(self.horizontalCount))
        
        // 先水平循环 后垂直循环
        for (var horizontal=0; horizontal<horizontalCount; horizontal++) {
            
            for(var vertical=0; vertical<verticalCount; vertical++) {
                
                let frame = CGRectMake(subWidth * CGFloat(horizontal),
                                       subHeight * CGFloat(vertical),
                                       subWidth,
                                       subHeight)
                let subLayer = CALayer()
                subLayer.frame = frame
                subLayer.backgroundColor = UIColor.blackColor().CGColor
                
                // 增加子mask
                maskLayer.addSublayer(subLayer)
                
                // 存放数组
                submaskLayers.append(subLayer)
            }
        }
    }
    
    // MARK: - 渐变显示、隐藏
    
    /**
     * 隐藏
     *
     * @param animated 是否执行动画
     */
    func hideAnimated(animated: Bool) {
        
        if animated {
            
            for(var i=0; i<submaskLayers.count; i++) {
                
                // 透明度动画类
                let opacityAnimationHide = CABasicAnimation(keyPath: "opacity")
                opacityAnimationHide.fromValue      = 1.0
                opacityAnimationHide.toValue        = 0.0
                opacityAnimationHide.duration       = self.duration
                opacityAnimationHide.beginTime      = CFTimeInterval(i) * 0.2 + CACurrentMediaTime()
                opacityAnimationHide.removedOnCompletion = false
                // 当动画结束后,layer会一直保持着动画最后的状态
                opacityAnimationHide.fillMode = kCAFillModeForwards
                
                // 增加动画
                self.submaskLayers[i].addAnimation(opacityAnimationHide, forKey: kOpacityAnimationHide)
            }
            
        } else {
            
            for(var i=0; i<submaskLayers.count; i++) {
                
                self.submaskLayers[i].opacity = 0
            }
        }
    }
    
    /**
     * 显示
     *
     * @param animated 是否执行动画
     */
    func showAnimated(animated: Bool) {
        
        if animated {
            
            for(var i=0; i<submaskLayers.count; i++) {
                
                // 透明度动画类
                let opacityAnimationShow = CABasicAnimation(keyPath: "opacity")
                opacityAnimationShow.fromValue      = 0.0
                opacityAnimationShow.toValue        = 1.0
                opacityAnimationShow.duration       = self.duration
                opacityAnimationShow.beginTime      = CFTimeInterval(i) * 0.2 + CACurrentMediaTime()
                opacityAnimationShow.removedOnCompletion = false
                //  当动画结束后,layer会一直保持着动画最后的状态
                opacityAnimationShow.fillMode = kCAFillModeForwards
                
                // 增加动画
                self.submaskLayers[i].addAnimation(opacityAnimationShow, forKey: kOpacityAnimationShow)
            }
        } else {
            
            for(var i=0; i<submaskLayers.count; i++) {
                
                self.submaskLayers[i].opacity = 1
            }
        }
    }
    
}
