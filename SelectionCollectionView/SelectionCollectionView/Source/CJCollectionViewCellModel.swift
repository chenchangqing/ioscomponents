//
//  CJCollectionViewCellModel.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CJCollectionViewCellModel: NSObject, NSCopying {
   
    var icon : UIImage? // 图片
    var title : String? // 标题
    
    // MARK: -
    
    init(icon: UIImage?, title: String?) {
        
        self.icon = icon
        self.title = title
    }
    
    /**
     * 重写比较
     */
    override func isEqual(object: AnyObject?) -> Bool {
        
        if let object=object as? CJCollectionViewCellModel {
            
            if object.icon == self.icon && object.title == self.title {
                
                return true
            }
        }
        return false
    }
    
    // MARK: -
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        
        return CJCollectionViewCellModel(icon: icon, title: title)
    }
}
