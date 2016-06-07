//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Daniel J Janiak on 6/6/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var detailImg: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationController?.toolbarItems.
        // self.navigationItem.backBarButtonItem
        
        
        
        imageView.image = detailImg
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    

}
