//
//  CJCollectionViewCell.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

/**
 * collectionView cell
 */
class CJCollectionViewCell: UICollectionViewCell {
    
    /**
     * icon
     */
    var icon : UIImage?
    {
        willSet {
            
            if let newValue = newValue {
                
                button.setImage(newValue, forState: UIControlState.Normal)
                button.setImage(newValue, forState: UIControlState.Selected)
            } else {
                
                button.setImage(nil, forState: UIControlState.Normal)
                button.setImage(nil, forState: UIControlState.Selected)
            }
        }
        
        didSet {
            
            changePaddingBetweenIconAndTitle()
        }
    }
    
    /**
     * title
     */
    var title: String?
    {
        willSet {
            
            button.setTitle(newValue, forState: UIControlState.Normal)
            button.setTitle(newValue, forState: UIControlState.Selected)
        }
    }
    
    private var button: UIButton!
    
    // MARK: - Constants
    
    /**
     * icon 与 title 之间的距离
     */
    private let marginBetweenIconAndTitle :CGFloat = 5
    
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
        
        changePaddingBetweenIconAndTitle()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        setupButton()
    }
    
    private func setupButton() {
        
        // create
        button = UIButton()
        button.generalStyle()
        button.homeStyle()
        
        // add
        contentView.addSubview(button)
        
        // constrains
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[button]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["button":button]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[button]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["button":button]))
    }
    
    // MARK: -
    
    /**
     * 改变 icon 与 title 之间的距离
     */
    private func changePaddingBetweenIconAndTitle() {
        
        if let icon = icon {
            
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, marginBetweenIconAndTitle)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        } else {
            
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
}
