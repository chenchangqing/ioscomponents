//
//  ViewController.swift
//  ImagePlayerView
//
//  Created by green on 15/8/17.
//  Copyright (c) 2015年 com.chenchangqing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var transformFadeView: TransformFadeView!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindSegueToViewController(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: -

    @IBAction func hide(sender: AnyObject) {
        
        transformFadeView.hideAnimated(true)
    }

    @IBAction func show(sender: AnyObject) {
        
        transformFadeView.showAnimated(true)
    }
}

