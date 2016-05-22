//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Daniel J Janiak on 5/22/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var topMemeText: UITextField!
    @IBOutlet var bottomMemeText: UITextField!
    
    var memeTextDelegate = MemeTextDelegate()
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -5
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topMemeText.delegate = memeTextDelegate
        self.bottomMemeText.delegate = memeTextDelegate
        
        topMemeText.attributedPlaceholder = NSAttributedString(string:"TOP", attributes: memeTextAttributes)
        bottomMemeText.attributedPlaceholder = NSAttributedString(string:"BOTTOM", attributes: memeTextAttributes)
        
        topMemeText.defaultTextAttributes = memeTextAttributes
        bottomMemeText.defaultTextAttributes = memeTextAttributes
        
        bottomMemeText.textAlignment = NSTextAlignment.Center
        topMemeText.textAlignment = NSTextAlignment.Center
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Hide the status bar so it doesn interfere with the top bar buttons
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

