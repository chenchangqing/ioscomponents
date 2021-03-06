//
//  DataHelper.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/24.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class DataHelper: NSObject {
   
    /**
     * 获得来自json的数据源
     */
    class func dataSource(fileName:String) -> OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]> {
        
        // 单例
        struct DataSourceSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>!
        }
        
        dispatch_once(&DataSourceSingleton.predicate, { () -> Void in
            
            DataSourceSingleton.instance = OrderedDictionary<CJCollectionViewHeaderModel,[CJCollectionViewCellModel]>()
            
            let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")!
            let data     = NSFileManager.defaultManager().contentsAtPath(filePath)

            if let data = data {
                
                var dataSource: [String:[[String:AnyObject]]]!
                
                do {
                    try
                    dataSource = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String : [[String : AnyObject]]]
                } catch {
                    
                    
                }
                
                for key in dataSource.keys {
                    
                    let keyData = key.dataUsingEncoding(NSUTF8StringEncoding)!
                    var keyDic : [String:AnyObject]!
                    
                    do {
                        try
                        keyDic = NSJSONSerialization.JSONObjectWithData(keyData, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
                    } catch {
                        
                    }
                    
                    let icon = keyDic["icon"] as? String
                    let title = keyDic["title"] as? String
                    let type = keyDic["type"] as? Int
                    let isExpend = keyDic["isExpend"] as? Bool
                    let isShowClearButton = keyDic["isShowClearButton"] as? Bool
                    let height = keyDic["height"] as? CGFloat
                    
                    let headerModel = CJCollectionViewHeaderModel(icon: icon, title: title)
                    if let type=type {
                        if let type=CJCollectionViewHeaderModelTypeEnum.instance(type) {
                            
                            headerModel.type = type
                        }
                    }
                    
                    if let isExpend=isExpend {
                        
                        headerModel.isExpend = isExpend
                    }
                    
                    if let isShowClearButton=isShowClearButton {
                        
                        headerModel.isShowClearButton = isShowClearButton
                    }
                    
                    if let height=height {
                        
                        headerModel.height = height
                    }
                    
                    
                    
                    var cellModels = [CJCollectionViewCellModel]()
                    let cellArray  = dataSource[key]!
                    
                    for cellDic in cellArray {
                        
                        let icon = cellDic["icon"] as? String
                        let title = cellDic["title"] as? String
                        let selected = cellDic["selected"] as? Bool
                        let width = cellDic["width"] as? CGFloat
                        
                        let cellModel = CJCollectionViewCellModel(icon: icon, title: title)
                        
                        if let selected=selected {
                            
                            cellModel.selected = selected
                        }
                        
                        if let width=width {
                            
                            cellModel.width = width
                        }
                        
                        cellModels.append(cellModel)
                    }
                    
                    DataSourceSingleton.instance[headerModel] = cellModels
                }
            }
        })
        
        return DataSourceSingleton.instance
    }
}
