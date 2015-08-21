//
//  CJSelectionCollectionView.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CJSelectionCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /**
     * 数据源
     */
    var dataSource = [String:[[String:String]]]() {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    /**
     * collection View 左边距
     */
    var collectionViewLeftMargin : CGFloat = 16
    
    /**
     * collection View 右边距
     */
    var collectionViewRightMargin : CGFloat = 16
    
    /**
     * collection View 上边距
     */
    var collectionViewTopMargin : CGFloat = 8
    
    /**
     * collection View 下边距
     */
    var collectionViewBottomMargin : CGFloat = 8
    
    /**
     * cell 之间的水平间距
     */
    var cellHorizontalMargin : CGFloat = 12
    
    private var collectionView : UICollectionView!
    
    
    // MARK: - Constants
    
    private let kDataSourceCellTitleKey                 = "Food_Name"   // cell title key
    private let kDataSourceCellIconKey                  = "Picture"    // cell icon  key
    
    private let kCellIdentifier             = "CellIdentifier"                // 重用单元格ID
    private let kHeaderViewCellIdentifier   = "HeaderViewCellIdentifier"      // 重用标题ID
    private let kCollectionView             = "collectionView"                // 增加约束时使用
    
    // MARK: -
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        // 初始化 collectionView
        setupCollectionView()
    }
    
    // MARK: -  处理数据
    
    /**
     * 返回指定节的key
     */
    private func keyForSection(section:Int) -> String {
        
        return dataSource.keys.array[section]
    }
    
    /**
     * 返回指定节的数据数组
     */
    private func arrayForSection(section:Int) -> [[String:String]] {
        
        return dataSource[keyForSection(section)]!
    }
    
    /**
     * 返回指定cell的数据字典
     */
    private func dictionaryForRow(indexPath:NSIndexPath) -> [String:String] {
        
        return arrayForSection(indexPath.section)[indexPath.row]
    }
    
    private func setupCollectionView() {
        
        // create
        let layout      = UICollectionViewLeftAlignedLayout()
        collectionView  = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        // 默认为黑色，这里设置为白色以便显示
        collectionView.backgroundColor = UIColor.whiteColor()
        
        // add collectionView
        self.addSubview(collectionView)
        
        // 重用Cell、Header
        collectionView.registerClass(CJCollectionViewCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        collectionView.registerClass(CJCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewCellIdentifier)
        
        // 设置collection代理为self
        collectionView.dataSource   = self
        collectionView.delegate     = self
        
        // add constrains
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[\(kCollectionView)]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: [kCollectionView: collectionView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[\(kCollectionView)]-0-|", options: NSLayoutFormatOptions(0), metrics: nil, views: [kCollectionView: collectionView]))
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    /**
     * cells count
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayForSection(section).count
    }
    
    /**
     * cell
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! CJCollectionViewCell
        
        // 处理数据
        let item            = dictionaryForRow(indexPath)
        let cellTitle       = item[kDataSourceCellTitleKey]
        let cellIcon        = item[kDataSourceCellIconKey]
        
        // 文字
        cell.title = cellTitle
        if let cellIcon = cellIcon {
            
            cell.icon = UIImage(named: cellIcon)
        }
        
        return cell
    }
    
    /**
    * sections count
    */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return dataSource.count
    }
    
    /**
    * header
    */
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewCellIdentifier, forIndexPath: indexPath) as! CJCollectionViewHeader
        
        // 处理数据
        header.titleButtonTitle = keyForSection(indexPath.section)
        header.titleButtonIcon  = UIImage(named: "home_btn_cosmetic")
        
        return header
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    /**
     * cell size
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(100, 30)
    }
    
    /**
     * collectionview edge
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(collectionViewTopMargin, collectionViewLeftMargin, collectionViewBottomMargin, collectionViewRightMargin)
    }
    
    /**
     * cell 左右之间的最小间距
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return cellHorizontalMargin
    }
    
    /**
     * header size
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSizeMake(CGRectGetWidth(self.bounds) - 50, 38)
    }

}
