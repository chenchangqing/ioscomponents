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
        
        self.selectionCollectionView.dataSource = DataHelper.dataSource("filter")
        selectionCollectionView.cellClicked = {(headerModel,cellModel) in
        
            print(cellModel.title, terminator: "\n")
        }
    }

}

