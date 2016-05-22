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
    
    var initialVerticalPosForView: CGFloat!
    
    var memeTextDelegate = MemeTextDelegate()
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -5
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialVerticalPosForView = self.view.frame.origin.y
        
        self.topMemeText.delegate = memeTextDelegate
        self.bottomMemeText.delegate = memeTextDelegate
        
        topMemeText.attributedPlaceholder = NSAttributedString(string:"TOP", attributes: memeTextAttributes)
        bottomMemeText.attributedPlaceholder = NSAttributedString(string:"BOTTOM", attributes: memeTextAttributes)
        
        topMemeText.defaultTextAttributes = memeTextAttributes
        bottomMemeText.defaultTextAttributes = memeTextAttributes
        
        bottomMemeText.textAlignment = NSTextAlignment.Center
        topMemeText.textAlignment = NSTextAlignment.Center
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomMemeText.isFirstResponder() {
            if self.view.frame.origin.y >= initialVerticalPosForView {
                self.view.frame.origin.y -= getKeyboardHeight(notification)
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        //print(self.view.frame.origin.y)
        //print(initialVerticalPosForView - getKeyboardHeight(notification))
        
        if bottomMemeText.isFirstResponder() {
            if self.view.frame.origin.y < initialVerticalPosForView {
                //self.view.frame.origin.y += getKeyboardHeight(notification)
                self.view.frame.origin.y = initialVerticalPosForView
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }

    
    // Hide the status bar so it doesn interfere with the top bar buttons
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

