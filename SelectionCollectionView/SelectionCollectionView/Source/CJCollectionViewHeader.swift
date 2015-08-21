//
//  CJCollectionReusableView.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

@objc protocol CJCollectionViewHeaderDelegate {
    
    func collectionViewHeaderMoreBtnClicked(sender:UIButton)
}

/**
 * collectionView header
 */
class CJCollectionViewHeader: UICollectionReusableView {
    
    /**
     * title button icon
     */
    var titleButtonIcon : UIImage?
    {
        willSet {
            
            titleButton.setImage(newValue, forState: UIControlState.Normal)
            titleButton.setImage(newValue, forState: UIControlState.Selected)
        }
    }
    
    /**
     * title button title
     */
    var titleButtonTitle: String?
    {
        willSet {
            
            titleButton.setTitle(newValue, forState: UIControlState.Normal)
            titleButton.setTitle(newValue, forState: UIControlState.Selected)
        }
    }
    
    /**
     * 左边距
     */
    var leftMargin :CGFloat = 16
    {
        willSet {
            
        }
    }
    
    /**
     * 右边距
     */
    var rightMargin: CGFloat = 16
    {
        willSet {
            
        }
    }
    
    /**
     * section
     */
    var section:Int = 0 {
        
        willSet {
            
            moreButton.tag = newValue
        }
    }
    
    /**
     * 是否隐藏更多按钮
     */
    var moreButtonHidden : Bool = false {
        
        willSet {
            
            moreButton.hidden = newValue
        }
    }
    
    /** 
     * 更多按钮是否被选中
     */
    var moreButtonSelected : Bool = false {
        
        willSet {
            
            moreButton.selected = newValue
        }
    }
    
    var delegate:CJCollectionViewHeaderDelegate?
    
    private var titleButton : UIButton! // 标题按钮
    private var clearButton : UIButton! // 清除按钮
    private var moreButton  : UIButton! // 更多按钮
    private var line        : UIView!   // 完美分割线
    
    private var constrainsViewDic = [String:UIView]() // 代码增加约束需要使用
    
    // MARK: - Constant
    private let kLineHeight         : CGFloat = 0.5 // 分割线高度
    private let kClearButtonWidth   : CGFloat = 72  // 清除按钮宽度
    private let kMoreButtonWidth    : CGFloat = 72  // 更多按钮宽度
    private let kMarginBetweenIconAndTitleForMoreButton : CGFloat = 7 //清除按钮 icon 与 title 之间的距离
    
    private let kTitleButton    = "titleButton"
    private let kClearButton    = "clearButton"
    private let kMoreButton     = "moreButton"
    private let kLine           = "line"
    
    // MARK: -
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 自动布局完后需要调整 moreButton titleButton
        moreButton.titleEdgeInsets = UIEdgeInsetsMake(
            0,
            -moreButton.imageView!.frame.size.width-kMarginBetweenIconAndTitleForMoreButton,
            0,
            moreButton.imageView!.frame.size.width)
        moreButton.imageEdgeInsets = UIEdgeInsetsMake(
            0,
            moreButton.titleLabel!.frame.size.width,
            0,
            -moreButton.titleLabel!.frame.size.width)
        
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0)
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0 , 0, 0)
    }
    
    // MARK: - SETUP
    
    private func setup() {
        
        // 初始化 moreButton
        setupMoreButton()
        
        // 初始化 clearButton
        setupClearButton()
        
        // 初始化 leftButton
        setupTitleButton()
        
        // 初始化 line
        setupLine()
    }
    
    private func setupMoreButton() {
        
        // create
        moreButton = UIButton()
        moreButton.setImage(UIImage(named: "home_btn_more_normal"), forState: UIControlState.Normal)
        moreButton.setImage(UIImage(named: "home_btn_more_selected"), forState: UIControlState.Selected)
        moreButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        moreButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected)
        moreButton.titleLabel?.textAlignment = NSTextAlignment.Right
        moreButton.setTitle("更多", forState: UIControlState.Normal)
        moreButton.setTitle("收起", forState: UIControlState.Selected)
        moreButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        
        // add to View
        self.addSubview(moreButton)
        
        // add constrains
        constrainsViewDic[kMoreButton] = moreButton
        
        moreButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[\(kMoreButton)]-\(kLineHeight)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: constrainsViewDic))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[\(kMoreButton)(\(kMoreButtonWidth))]-\(rightMargin)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: constrainsViewDic))
        
        // event
        moreButton.addTarget(self, action: Selector("moreBtnClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupClearButton() {
        
        // create
        clearButton = UIButton()
        clearButton.setTitle("清除", forState: UIControlState.Normal)
        clearButton.setTitle("清除", forState: UIControlState.Selected)
        clearButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        clearButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected)
        clearButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        
        // add to View
        self.addSubview(clearButton)
        
        // add constrains
        constrainsViewDic[kClearButton] = clearButton
        
        clearButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[\(kClearButton)]-\(kLineHeight)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: constrainsViewDic))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[\(kClearButton)(\(kClearButtonWidth))]-8-[\(kMoreButton)]", options: NSLayoutFormatOptions(0), metrics: nil, views: constrainsViewDic))
    }
    
    private func setupTitleButton() {
        
        // create
        titleButton = UIButton()
        titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        titleButton.titleLabel?.textAlignment = NSTextAlignment.Left
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected)
        
        // add to View
        self.addSubview(titleButton)
        
        // add constrains
        constrainsViewDic[kTitleButton] = titleButton
        
        titleButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[\(kTitleButton)]-\(kLineHeight)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: constrainsViewDic))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftMargin)-[\(kTitleButton)]-8-[\(kClearButton)]", options: NSLayoutFormatOptions(0), metrics: nil, views: constrainsViewDic))
    }
    
    private func setupLine() {
        
        // create
        line                    = UIView()
        line.backgroundColor    = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1)
        
        // add to View
        self.addSubview(line)
        
        // add constrains
        constrainsViewDic[kLine] = line
        
        line.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[\(kLine)(\(kLineHeight))]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: constrainsViewDic))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(leftMargin)-[\(kLine)]-\(rightMargin)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: constrainsViewDic))
    }
    
    // MARK: - moreBtn clicked
    
    func moreBtnClicked(sender:UIButton) {
        
        if let delegate=delegate {
            
            delegate.collectionViewHeaderMoreBtnClicked(sender)
        }
    }
    
}
