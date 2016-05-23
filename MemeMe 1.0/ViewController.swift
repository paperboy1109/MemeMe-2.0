//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Daniel J Janiak on 5/22/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var topMemeText: UITextField!
    @IBOutlet var bottomMemeText: UITextField!
    @IBOutlet var memeView: UIImageView!
    @IBOutlet var cameraBtn: UIBarButtonItem!
    @IBOutlet var shareBtn: UIBarButtonItem!
    @IBOutlet var topToolbar: UIToolbar!
    @IBOutlet var bottomToolbar: UIToolbar!
    
    var initialVerticalPosForView: CGFloat!
    
    var memeTextDelegate = MemeTextDelegate()
    let pickerController = UIImagePickerController()
    
    struct Meme {
        var topMemeText: String?
        var bottomMemeText: String?
        var originalImg: UIImage?
        var memeImg: UIImage?
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -5
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialVerticalPosForView = self.view.frame.origin.y
        
        pickerController.delegate = self
        
        self.topMemeText.delegate = memeTextDelegate
        self.bottomMemeText.delegate = memeTextDelegate
        
        setPlaceholderText()
        
        topMemeText.defaultTextAttributes = memeTextAttributes
        bottomMemeText.defaultTextAttributes = memeTextAttributes
        
        bottomMemeText.textAlignment = NSTextAlignment.Center
        topMemeText.textAlignment = NSTextAlignment.Center
        
        shareBtn.enabled = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

        self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    // Actions when toolbar buttons are tapped
    
    @IBAction func pickAlbumImage(sender: AnyObject) {
        
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickCameraImg(sender: AnyObject) {
        
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func launchActivityView() {
        
        //let image = UIImage()
        let newMeme = generateMemedImg()
        
        //let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        let controller = UIActivityViewController(activityItems: [newMeme], applicationActivities: nil)
        
        self.presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) in
            print("Activity: \(activityType) Success: \(completed) Items: \(returnedItems) Error: \(activityError)")
            
            if activityError == nil {
                self.save()
                controller.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        
    }
    
    // Actions for updating the image
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeView.image = pickedImage
            
            shareBtn.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelMeme() {
        
        memeView.image = nil
        setPlaceholderText()
        
    }
    
    func setPlaceholderText() {
        
        topMemeText.text = ""
        bottomMemeText.text = ""
        
        topMemeText.attributedPlaceholder = NSAttributedString(string:"TOP", attributes: memeTextAttributes)
        bottomMemeText.attributedPlaceholder = NSAttributedString(string:"BOTTOM", attributes: memeTextAttributes)
        
    }
    
    // Actions for sharing the meme
    func save() {
        
        let newMeme = generateMemedImg()
        let meme = Meme( topMemeText: topMemeText.text!, bottomMemeText: bottomMemeText.text!, originalImg: memeView.image, memeImg: newMeme)
    }
    
    func generateMemedImg() -> UIImage {
        
        // Hide the toolbars
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let memedImg: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show the toolbars
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImg
    }
    
    
    // Don't let the keyboard obstruct the view
    
    
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
        
        if bottomMemeText.isFirstResponder() {
            if self.view.frame.origin.y < initialVerticalPosForView {
                //self.view.frame.origin.y += getKeyboardHeight(notification)
                self.view.frame.origin.y = initialVerticalPosForView
            }
        }
        
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

