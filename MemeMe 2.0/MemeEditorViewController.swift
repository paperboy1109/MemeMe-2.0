//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Daniel J Janiak on 5/22/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var topMemeText: UITextField!
    @IBOutlet var bottomMemeText: UITextField!
    @IBOutlet var memeView: UIImageView!
    @IBOutlet var cameraBtn: UIBarButtonItem!
    @IBOutlet var shareBtn: UIBarButtonItem!
    @IBOutlet var topToolbar: UIToolbar!
    @IBOutlet var bottomToolbar: UIToolbar!
    @IBOutlet var cancelBtn: UIBarButtonItem!
    
    var initialVerticalPosForView: CGFloat!
    
    var memeTextDelegate = MemeTextDelegate()
    let pickerController = UIImagePickerController()
    
    /*
    struct Meme {
        var topMemeText: String?
        var bottomMemeText: String?
        var originalImg: UIImage?
        var memeImg: UIImage?
    }
    */
    
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
        
        setupTextField(topMemeText)
        setupTextField(bottomMemeText)
        
        setPlaceholderText(topMemeText, initialText: "TOP")
        setPlaceholderText(bottomMemeText, initialText: "BOTTOM")
        
        
        shareBtn.enabled = false
        /*
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBarHidden = true
        */
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

        subscribeToKeyboardNotifications()
        
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBarHidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // Actions when toolbar buttons are tapped
    
    @IBAction func pickAlbumImage(sender: AnyObject) {
        
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickCameraImg(sender: AnyObject) {
        
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        
        presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func launchActivityView() {
        
        let newMeme = generateMemedImg()
        
        let controller = UIActivityViewController(activityItems: [newMeme], applicationActivities: nil)
        
        presentViewController(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) in
            
            if activityError == nil {
                if completed {
                    self.save(newMeme)
                }
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
        setPlaceholderText(topMemeText, initialText: "TOP")
        setPlaceholderText(bottomMemeText, initialText: "BOTTOM")
        shareBtn.enabled = false
        
        // dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("SentMemesVC", sender: nil)
        
    }
    
    func setPlaceholderText(textField: UITextField, initialText: String) {
        
        textField.text = ""
        
        textField.attributedPlaceholder = NSAttributedString(string: initialText, attributes: memeTextAttributes)
        
        
    }
    
    func setupTextField(textField: UITextField) {
        
        textField.delegate = memeTextDelegate
        
        textField.defaultTextAttributes = memeTextAttributes
        
        textField.textAlignment = NSTextAlignment.Center
        
    }
    
    // Actions for sharing the meme
    func save(newMeme: UIImage) {
        
        let newMeme = Meme( topMemeText: topMemeText.text!, bottomMemeText: bottomMemeText.text!, originalImg: memeView.image, memeImg: newMeme)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(newMeme)
    }
    
    func generateMemedImg() -> UIImage {
        
        // Hide the toolbars so that they are not in the meme
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        
        let memedImg: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Add it to the sentMemes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.sentMemes.append(memedImg)
        
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
                self.view.frame.origin.y = -getKeyboardHeight(notification)
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if bottomMemeText.isFirstResponder() {
            if self.view.frame.origin.y < initialVerticalPosForView {
                self.view.frame.origin.y = initialVerticalPosForView
            }
        }
        
    }

    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }

    
    // Hide the status bar so it doesn interfere with the top bar buttons
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //
    func doubleTapped() -> Bool {
        return true
    }

}

