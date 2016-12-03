//
//  ViewController.swift
//  Meme Me V1.0
//
//  Created by Michael Doroff on 11/18/16.
//  Copyright © 2016 Michael Doroff. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    let topMemeDelegate = MemeTextFieldDelegateClass()
    let bottomMemeDelegate = MemeTextFieldDelegateClass()
    
    
    var generatedMeme: UIImage?
    
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.00]
    
    
    struct Meme {
    /* This struct stores information about the Meme */
        let topText: String?
        let bottomText: String?
        let originalImage: UIImage?
        let memedImage: UIImage?
        

    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField(textField: textField1, withtext: "TOP", delegate: topMemeDelegate, textAttributes: memeTextAttributes)
        
         configureTextField(textField: textField2, withtext: "BOTTOM", delegate: bottomMemeDelegate, textAttributes: memeTextAttributes)
        
        
        
        
        
        
        if let _ = imagePickerView.image {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }

    
    }
    
    @IBAction func callPickAnImageFromCamera(_ sender: Any) {
       
        pickAnImage(sourceType: .camera)
    
    
    
    }

    @IBAction func callActivityViewController(_ sender: Any) {
    
        generatedMeme = generateMemedImage()
        
        
        var sharedActivityViewController = UIActivityViewController(activityItems: [generatedMeme], applicationActivities: [])
        
        
        present(sharedActivityViewController, animated: true, completion: nil)
        
      sharedActivityViewController.completionWithItemsHandler = { (activity: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
        
            self.save()
        
        }
    }
    
        
    @IBAction func callPickAnImageViewController(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        pickAnImage(sourceType: .photoLibrary)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = -(getKeyboardHeight(notification: notification))
    }
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y += (getKeyboardHeight(notification: notification))
    }

    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userinfo = notification.userInfo
        let keyboardSize = userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
    func subscribeToKeyboardNotifications()  {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        navigationBar.isHidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        
        toolBar.isHidden = false
        navigationBar.isHidden = false
        
        
        
        return memedImage
    }
    func save() {
        // Create the meme
        let _ = Meme(topText: textField1.text!, bottomText: textField2.text!, originalImage: imagePickerView.image!, memedImage: generatedMeme!)
    }
    
    func configureTextField(textField:UITextField, withtext text: String, delegate: UITextFieldDelegate, textAttributes: [String:Any]) {
        
        textField.delegate = delegate
        textField.text! = text
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = .center
    }
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
         let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
        
        
        
        
        
    }
    
}

