//
//  CJCollectionViewHeaderModel.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

enum CJCollectionViewHeaderModelType : Int {
    
    case MultipleChoice = 0 // 多选
    case SingleChoice   = 1 // 单选
    case SingleClick    = 2 // 单击
}

class CJCollectionViewHeaderModel: NSObject {
    
    var icon : String? // 图片
    var title : String? // 标题
    var type: CJCollectionViewHeaderModelType = .MultipleChoice // 该分类下按钮类型
    
    // MARK: -
    
    init(icon: String?, title: String?) {
        
        self.icon = icon
        self.title = title
    }
    
    init(icon: String?, title: String?, selected: Bool) {
        
        self.icon = icon
        self.title = title
    }
    
    init(icon: String?, title: String?, selected: Bool, type: CJCollectionViewHeaderModelType) {
        
        self.icon = icon
        self.title = title
        self.type = type
    }
    
    required init(coder decoder: NSCoder) {
        
        self.icon         = decoder.decodeObjectForKey("icon") as! String?
        self.title        = decoder.decodeObjectForKey("title") as! String?
        self.type         = CJCollectionViewHeaderModelType(rawValue:decoder.decodeObjectForKey("type") as! Int)!
        
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        
        encoder.encodeObject(self.icon,forKey: "icon")
        encoder.encodeObject(self.title,forKey: "title")
        encoder.encodeObject(self.type.rawValue, forKey: "type")
    }
    
    // MARK: - 重写比较方法
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        if let object=object as? CJCollectionViewHeaderModel {
            
            if object.icon == self.icon && object.title == self.title {
                
                return true
            }
        }
        return false
    }
    
    override var description: String {
        
        get {
            
            return "{header.title:\(title!)}"
        }
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        
        return CJCollectionViewHeaderModel(icon: icon, title: title)
    }
   
}
