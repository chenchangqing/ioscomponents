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
    
    var icon    : String? // 图片
    var title   : String? // 标题
    var type    : CJCollectionViewHeaderModelType = .MultipleChoice // 该分类下按钮类型
    var isExpend : Bool = true  // 是否展开
    var isShowClearButton: Bool = false // 是否现实清除按钮
    
    // MARK: -
    
    init(icon: String?, title: String?) {
        
        self.icon = icon
        self.title = title
    }
    
    init(icon: String?, title: String?, type: CJCollectionViewHeaderModelType) {
        
        self.icon = icon
        self.title = title
        self.type = type
    }
    
    init(icon: String?, title: String?, type: CJCollectionViewHeaderModelType,isExpend:Bool) {
        
        self.icon = icon
        self.title = title
        self.type = type
        self.isExpend = isExpend
    }
    
    init(icon: String?, title: String?, type: CJCollectionViewHeaderModelType,isExpend:Bool, isShowClearButton:Bool) {
        
        self.icon = icon
        self.title = title
        self.type = type
        self.isExpend = isExpend
        self.isShowClearButton = isShowClearButton
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        
        return CJCollectionViewHeaderModel(icon: icon, title: title)
    }
    
    required init(coder decoder: NSCoder) {
        
        self.icon         = decoder.decodeObjectForKey("icon") as? String
        self.title        = decoder.decodeObjectForKey("title") as? String
        self.type         = CJCollectionViewHeaderModelType(rawValue:decoder.decodeObjectForKey("type") as! Int)!
        self.isExpend        = decoder.decodeObjectForKey("isExpend") as! Bool
        self.isShowClearButton        = decoder.decodeObjectForKey("isShowClearButton") as! Bool
        
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        
        encoder.encodeObject(self.icon,forKey: "icon")
        encoder.encodeObject(self.title,forKey: "title")
        encoder.encodeObject(self.type.rawValue, forKey: "type")
        encoder.encodeObject(self.isExpend,forKey: "isExpend")
        encoder.encodeObject(self.isShowClearButton,forKey: "isShowClearButton")
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
    
    // MARK: - 重写描述
    
    override var description: String {
        
        get {
            
            return "{header.title:\(title!)}"
        }
    }
    
}
