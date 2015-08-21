//
//  CJSelectionCollectionView.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CJSelectionCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate,CJCollectionViewHeaderDelegate {
    
    /**
     * 数据源
     */
    var dataSource = [CJCollectionViewHeaderModel:[CJCollectionViewCellModel]]() {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    /**
     * collection View 左边距
     */
    var collectionViewLeftMargin : CGFloat = 16  {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    /**
     * collection View 右边距
     */
    var collectionViewRightMargin : CGFloat = 16 {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    /**
     * collection View 上边距
     */
    var collectionViewTopMargin : CGFloat = 8 {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    /**
     * collection View 下边距
     */
    var collectionViewBottomMargin : CGFloat = 8 {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    /**
     * cell 之间的水平间距
     */
    var cellHorizontalMargin : CGFloat = 12 {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    /**
     * cell 可以改变cell中内容到左右边界的距离
     */
    var cellHorizontalPadding : CGFloat = 16 {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    /**
     * 默认显示行数
     */
    var defaultRows:Int = 1 {
        
        didSet {
            
            collectionView.reloadData()
        }
    }
    
    private var collectionView : UICollectionView!
    // 每个分类下有几行，每行有几个cell
    private var cellCountDictionary :[CJCollectionViewHeaderModel:[Int]]!
    
    // 每个分类下默认显示行包含的cell数量
    private var defaultCellCountForSectionDictionary :[CJCollectionViewHeaderModel:Int]!
    // 每个分类下是否应该显示更多按钮字典
    private var isShowMoreBtnDictionary :[CJCollectionViewHeaderModel:Bool]!
    
    // 每个分类下是否已经被展开
    private lazy var expandSectionArray = [CJCollectionViewHeaderModel:Bool]()
    
    
    // MARK: - Constants
    
    private let kCellIdentifier             = "CellIdentifier"                // 重用单元格ID
    private let kHeaderViewCellIdentifier   = "HeaderViewCellIdentifier"      // 重用标题ID
    private let kCollectionView             = "collectionView"                // 增加约束时使用
    private let kCollectionViewCellHeight   : CGFloat          = 30           // cell height
    
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
        
        // 计算
        cellCountDictionary = caculateCellCountForEveryRowInSection()
        defaultCellCountForSectionDictionary = caculateDefaultCellCountForSection()
        isShowMoreBtnDictionary = caculateIsShowMoreBtn()
        expandSectionArray = [CJCollectionViewHeaderModel:Bool]()
    }
    
    // MARK: - setup
    
    private func setup() {
        
        // 初始化 collectionView
        setupCollectionView()
    }
    
    /**
     * 初始化 collectionView
     */
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
    
    // MARK: -  处理数据
    
    /**
     * 返回指定节的key
     */
    private func keyForSection(section:Int) -> CJCollectionViewHeaderModel {
        
        return dataSource.keys.array[section]
    }
    
    /**
     * 返回指定节的数据数组
     */
    private func arrayForSection(section:Int) -> [CJCollectionViewCellModel] {
        
        return dataSource[keyForSection(section)]!
    }
    
    /**
     * 返回指定cell的数据字典
     */
    private func dictionaryForRow(indexPath:NSIndexPath) -> CJCollectionViewCellModel {
        
        return arrayForSection(indexPath.section)[indexPath.row]
    }
    
    // MARK: - UICollectionViewDataSource
    
    /**
     * cells count
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let key = keyForSection(section)
        
        if let flag = expandSectionArray[key] {
            
            if flag {
                
                return arrayForSection(section).count
            }
        }
        
        return defaultCellCountForSectionDictionary[key]!
    }
    
    /**
     * cell
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! CJCollectionViewCell
        
        // 处理数据
        let item            = dictionaryForRow(indexPath)
        let cellTitle       = item.title
        let cellIcon        = item.icon
        
        // 文字
        cell.title = cellTitle
        if let cellIcon = cellIcon {
            
            cell.icon = UIImage(named: cellIcon)
        } else {
            
            cell.icon = nil
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
        header.titleButtonTitle = keyForSection(indexPath.section).title
        
        if let icon=keyForSection(indexPath.section).icon {
            
            header.titleButtonIcon  = UIImage(named: icon)
        }
        
        // 记录位置
        header.section = indexPath.section
        
        // 是否显示更多
        let key = keyForSection(indexPath.section)
        
        header.moreButtonHidden = !isShowMoreBtnDictionary[key]!
        
        // 设置更多按钮的状态
        if let flag = expandSectionArray[key] {
            if flag {
                
                header.moreButtonSelected = true
            } else {
                
                header.moreButtonSelected = false
            }
        }
        
        // delegate
        header.delegate = self
        
        return header
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    /**
     * cell size
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellModel = dictionaryForRow(indexPath)
        let cellWidth = caculateCellWidth(cellModel)
        
        return CGSizeMake(cellWidth, kCollectionViewCellHeight)
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
    
    // MARK: - CJCollectionViewHeaderDelegate
    
    func collectionViewHeaderMoreBtnClicked(sender: UIButton) {
        
        sender.selected = !sender.selected
        
        let key = keyForSection(sender.tag)
        expandSectionArray[key] = sender.selected
        
        // 更新collectionView
        collectionView.performBatchUpdates({ () -> Void in
            
            let section = NSIndexSet(index: sender.tag)
            self.collectionView.reloadSections(section)
        }, completion: { (finished) -> Void in
                
        })
    }
    
    // MARK: - caculate
    
    /**
     * 计算cell的width
     *
     * @param cell单元格数据
     *
     * @return cell的宽度
     */
    private func caculateCellWidth(cellModel:CJCollectionViewCellModel) -> CGFloat {
        
        var cellWidth:CGFloat = 0
        
        let limitWidth = CGRectGetWidth(collectionView.frame) - collectionViewLeftMargin - collectionViewRightMargin
        
        if let title = cellModel.title {
            
            let size  = title.sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(16)])
            cellWidth = CGFloat(ceilf(Float(size.width))) + cellHorizontalPadding
            
            if let icon=cellModel.icon {
                
                // 如果包含图片，增加item的宽度
                cellWidth += cellHorizontalPadding
            }
            
            // 如果通过文字+图片计算出来的宽度大于等于限制宽度，则改变单元格item的实际宽度
            cellWidth = cellWidth >= limitWidth ? limitWidth : cellWidth
        }
        
        return cellWidth
    }
    
    /**
     * 计算cell所占据的最大宽度
     *
     * @param cell单元格数据
     * @index cell位置
     *
     * @return cell所占据的最大宽度
     */
    private func caculateCellLimitWidth (cellModel:CJCollectionViewCellModel,indexAtItems index:Int) -> CGFloat {
        
        let contentViewWidth = CGRectGetWidth(collectionView.frame) - collectionViewLeftMargin - collectionViewRightMargin
        
        // 计算单元格cell的实际宽度
        let cellWidth = caculateCellWidth(cellModel)
        
        // 单元格占据的宽度，用于计算该单元格属于哪一行
        var limitWidth : CGFloat!
        
        // 如果cell的实际宽度等于最大限制宽度，那么cell占据宽度等于最大限制宽度
        if cellWidth == contentViewWidth {
            
            limitWidth = cellWidth
        } else {
            
            // 如果单元格cell是数组中第一个，那么不需要+水平间距
            if index == 0 {
                
                limitWidth = cellWidth
            } else {
                
                let contentViewWidth2 = contentViewWidth - cellHorizontalMargin
                
                if cellWidth >= contentViewWidth2 {
                    
                    // 如果单元格item不是第一个，而且itemWidth大于最大限制宽度-水平间距，那么item占据宽度为最大限制
                    limitWidth = contentViewWidth
                } else {
                    
                    // 正常占据
                    limitWidth = cellWidth + cellHorizontalMargin
                }
            }
        }
        return limitWidth
    }
    
    /**
     * 计算第一行包含的cell数量
     *
     * @param cellModels 单元格数据数组
     *
     * @return 第一行包含的cell数量
     */
    private func caculateCellCountForFirstRow(cellModels:[CJCollectionViewCellModel]) -> Int {
        
        var cellCount: Int   = 0
        let contentViewWidth = CGRectGetWidth(collectionView.frame) - collectionViewLeftMargin - collectionViewRightMargin
        
        let widthArray = NSMutableArray()
        
        for (var i=0; i<cellModels.count; i++) {
            
            let limitWidth = caculateCellLimitWidth(cellModels[i], indexAtItems: i)
            widthArray.addObject(limitWidth)
            
            let sumArray = NSArray(array: widthArray)
            let sum:CGFloat = sumArray.valueForKeyPath("@sum.self") as! CGFloat
            
            if sum <= contentViewWidth {
                
                cellCount++
            } else {
                break
            }
        }
        
        return cellCount
    }
    
    /**
     * 计算每一行包含的cell数量数组
     * @param cellModels 单元格数据数组
     *
     * @return 每一行包含的cell数量数组
     */
    private func caculateCellCountForEveryRow(var cellModels:[CJCollectionViewCellModel]) -> [Int] {
        
        var resultArray = [Int]()
        let tempArray = NSMutableArray(array: cellModels)
        
        let cellCount = caculateCellCountForFirstRow(cellModels)
        resultArray.append(cellCount)
        
        for item in tempArray {
            
            let cellCount = caculateCellCountForFirstRow(cellModels)
            
            if cellModels.count != cellCount {
                
                cellModels.removeRange(Range(start: 0, end: cellCount))
                
                let cellCount = caculateCellCountForFirstRow(cellModels)
                resultArray.append(cellCount)
            }
        }
        return resultArray
    }
    
    // MARK: - 业务
    
    /**
     * 计算每个分类每一行包含的cell数量字典
     *
     * @return 每个分类每一行包含的cell数量字典
     */
    private func caculateCellCountForEveryRowInSection() -> [CJCollectionViewHeaderModel:[Int]] {
        
        var resultDic = [CJCollectionViewHeaderModel:[Int]]()
        
        for key in dataSource.keys.array {
            
            let tempArray = caculateCellCountForEveryRow(dataSource[key]!)
            resultDic[key] = tempArray
        }
        return resultDic
    }
    
    /**
     * 计算每个分类下默认显示的行数包含cell的数量字典
     * 
     * @return 每个分类下默认显示的行数包含cell的数量字典
     */
    private func caculateDefaultCellCountForSection() -> [CJCollectionViewHeaderModel:Int] {
        
        var resultDic = [CJCollectionViewHeaderModel:Int]()
        
        for key in cellCountDictionary.keys.array {
            
            var sum: Int = 0
            let cellCountForEveryRowArray = cellCountDictionary[key]!
            
            for (var i=0; i<cellCountForEveryRowArray.count; i++) {
                
                if i < defaultRows {
                    
                    sum += cellCountForEveryRowArray[i]
                } else {
                    
                    break
                }
            }
            resultDic[key] = sum
        }
        
        return resultDic
    }
    
    /**
     * 计算每个分类下是否应该显示更多按钮字典
     * 
     * @return 每个分类下是否应该显示更多按钮字典
     */
    private func caculateIsShowMoreBtn() -> [CJCollectionViewHeaderModel: Bool] {
        
        var resultDic = [CJCollectionViewHeaderModel: Bool]()
        
        for key in cellCountDictionary.keys.array {
            
            let cellCountForEveryRowArray = cellCountDictionary[key]!
            
            if cellCountForEveryRowArray.count > defaultRows {
                
                resultDic[key] = true
            } else {
                
                resultDic[key] = false
            }
        }
        
        return resultDic
    }

}
