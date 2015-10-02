//
//  MemeEditorViewController.swift
//  MemeMe v.01
//
//  Created by MIRKO on 9/29/15.
//  Copyright © 2015 XZM. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    // text default attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // setting up textFields
        textFieldSetUp(textTop)
        textFieldSetUp(textBottom)
        textTop.delegate = self
        textBottom.delegate = self
        shareButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Notification subscription
        subscribeToKeyboardNotifications()
        subscribeToKeyboardNotificationDismiss()
        // Disable camera button if there is no camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Notification unsubscription
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardNotificationDismiss()
    }
    


    @IBAction func pickImage(sender: AnyObject) {
        // create a view to pick images
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
        
        
    }
    @IBAction func takePhoto(sender: AnyObject) {
        // create a view to take a picture
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // set image selected by user
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImage.contentMode = .ScaleAspectFill
            memeImage.image = image
            shareButton.enabled = true


            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // dismisses the view if the selection is canceled
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("hello")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // subscribe to notification
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
    }
    
    // unsubscribe from notification
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    // triggers when the notification arrives
    func keyboardWillShow(notification: NSNotification) {
        if textBottom.isFirstResponder(){
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    // function to obtain keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // For returning the view to normal when keyboard is dimissed
    // subscribe to notification
    func subscribeToKeyboardNotificationDismiss() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // unsubscribe from notification
    func unsubscribeFromKeyboardNotificationDismiss() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // trigger when the notification arrives
    func keyboardWillHide(notification: NSNotification) {
        if textBottom.isFirstResponder(){
        view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    // Dismiss keyboard when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Function to chapitalize all characters
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var replacedChar = false
        // Replace lower case characters
        var newText = textField.text! as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        var lowercaseCharRange : NSRange
        lowercaseCharRange = newText.rangeOfCharacterFromSet(NSCharacterSet .lowercaseLetterCharacterSet())
        
        if (lowercaseCharRange.location != NSNotFound) {
            newText = newText.stringByReplacingCharactersInRange(lowercaseCharRange, withString: string.uppercaseString)
            replacedChar = true
            
        }
        
        if replacedChar {
            textField.text = newText as String
            return false
        } else {
            return true
        }
    }
    
    func generateMemedImage() -> UIImage {
        // capture a meme with overlay text, hide not needed features
        navbar.hidden = true
        toolbar.hidden = true
        textTop.hidden = true
        textBottom.hidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navbar.hidden = false
        toolbar.hidden = false
        textTop.hidden = false
        textBottom.hidden = false
        
        
        return memedImage
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        // Create an activity view and pass the selected image
        let memedImage = generateMemedImage()
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        nextController.completionWithItemsHandler = {(type: String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                self.save()
                self.presentingViewController?.dismissViewControllerAnimated(true, completion:nil)
            }
        }
        presentViewController(nextController, animated: true, completion: nil)
    }
    

    func save() {
        //Create a Meme struct instance
        let meme = Meme(stringTop: textTop.text!, stringBottom: textBottom.text!, image: memeImage.image!, memedImage: generateMemedImage())
    }
    
    @IBAction func cancelReset(sender: AnyObject) {
        // pressing cancel button resets the view to original state
        memeImage.image = nil
        textFieldSetUp(textTop)
        textFieldSetUp(textBottom)
        shareButton.enabled = false
    }
    
    func textFieldSetUp(textfield: UITextField) {
        textfield.text = "Insert your Text".uppercaseString
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = NSTextAlignment.Center
        textfield.autocapitalizationType = UITextAutocapitalizationType.AllCharacters

    }
}

