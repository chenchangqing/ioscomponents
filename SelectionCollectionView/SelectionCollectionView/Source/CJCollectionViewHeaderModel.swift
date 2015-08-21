//
//  CJCollectionViewHeaderModel.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CJCollectionViewHeaderModel: NSObject {
    
    var icon : String? // 图片
    var title : String? // 标题
    
    // MARK: -
    
    init(icon: String?, title: String?) {
        
        self.icon = icon
        self.title = title
    }
    
    /**
    * 重写比较
    */
    override func isEqual(object: AnyObject?) -> Bool {
        
        if let object=object as? CJCollectionViewHeaderModel {
            
            if object.icon == self.icon && object.title == self.title {
                
                return true
            }
        }
        return false
    }
    
    // MARK: -
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        
        return CJCollectionViewHeaderModel(icon: icon, title: title)
    }
   
}
