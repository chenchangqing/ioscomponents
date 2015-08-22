//
//  ViewController.swift
//  SelectionCollectionView
//
//  Created by green on 15/8/21.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var selectionCollectionView: CJSelectionCollectionView!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SETUP
    
    private func setup() {
        
        // 初始化 selectionCollectionView
        setupSelectionCollectionView()
    }
    
    private func setupSelectionCollectionView() {
        
        self.selectionCollectionView.dataSource = self.getDataSource()
        selectionCollectionView.cellClicked = {cellModel in
        
            println(cellModel.title)
        }
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 5)), dispatch_get_main_queue()) { () -> Void in
            
            
            println(self.selectionCollectionView.resultArray)
        }
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 10)), dispatch_get_main_queue()) { () -> Void in
//            
//            self.selectionCollectionView.type = .MultipleChoice
//        }
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC * 15)), dispatch_get_main_queue()) { () -> Void in
//            
//            self.selectionCollectionView.type = .SingleClick
//        }
    }
    
    // MARK: -
    
    /**
     * 获得数据源
     */
    private func getDataSource() -> [CJCollectionViewHeaderModel:[CJCollectionViewCellModel]] {
        
        // 单例
        struct DataSourceSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:[CJCollectionViewHeaderModel:[CJCollectionViewCellModel]]!
        }
        
        dispatch_once(&DataSourceSingleton.predicate, { () -> Void in
            
            DataSourceSingleton.instance = [CJCollectionViewHeaderModel:[CJCollectionViewCellModel]]()
            
            let filePath = NSBundle.mainBundle().pathForResource("data", ofType: "json")!
            let data     = NSFileManager.defaultManager().contentsAtPath(filePath)
            var error:NSError?
            if let data = data {
                
                let dataSource = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! [String:[[String:String]]]
                
                for key in dataSource.keys.array {
                    
                    let keyData = key.dataUsingEncoding(NSUTF8StringEncoding)!
                    let keyDic  = NSJSONSerialization.JSONObjectWithData(keyData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! [String:String]
                    
                    let icon = keyDic["icon"]
                    let title = keyDic["title"]
                    
                    let headerModel = CJCollectionViewHeaderModel(icon: icon, title: title)
                    
                    var cellModels = [CJCollectionViewCellModel]()
                    let cellArray  = dataSource[key]!
                    
                    for cellDic in cellArray {
                        
                        let icon = cellDic["icon"]
                        let title = cellDic["title"]
                        
                        let cellModel = CJCollectionViewCellModel(icon: icon, title: title)
                        cellModels.append(cellModel)
                    }
                    
                    DataSourceSingleton.instance[headerModel] = cellModels
                }
            }
        })
        
        return DataSourceSingleton.instance
    }

}

