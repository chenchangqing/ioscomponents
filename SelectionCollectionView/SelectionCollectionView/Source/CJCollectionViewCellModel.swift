//
//  CJCollectionViewCellModel.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class CJCollectionViewCellModel: NSObject {
   
    var icon : String? // 图片
    var title : String? // 标题
    var selected : Bool = false // 是否全选
    
    // MARK: -
    
    init(icon: String?, title: String?) {
        
        self.icon = icon
        self.title = title
    }
    
    init(icon: String?, title: String?, selected: Bool) {
        
        self.icon = icon
        self.title = title
        self.selected = selected
    }
    
    required init(coder decoder: NSCoder) {
        
        self.icon         = decoder.decodeObjectForKey("icon") as! String?
        self.title        = decoder.decodeObjectForKey("title") as! String?
        self.selected     = decoder.decodeObjectForKey("selected") as! Bool
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        
        encoder.encodeObject(self.icon,forKey: "icon")
        encoder.encodeObject(self.title,forKey: "title")
        encoder.encodeObject(self.selected, forKey: "selected")
    }
    
    // MARK: - 重写比较方法
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if let object=object as? CJCollectionViewCellModel {
            
            if object.icon == self.icon && object.title == self.title {
                
                return true
            }
        }
        return false
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        
        return CJCollectionViewCellModel(icon: icon, title: title)
    }
}
