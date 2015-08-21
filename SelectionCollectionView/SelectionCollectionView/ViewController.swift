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
        
        selectionCollectionView.dataSource = getDataSource()
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
                
                let dataSource = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
                println(dataSource)
            }
        })
        
        return DataSourceSingleton.instance
    }

}

