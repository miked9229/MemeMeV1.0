//
//  ViewController.swift
//  Meme Me V1.0
//
//  Created by Michael Doroff on 11/18/16.
//  Copyright © 2016 Michael Doroff. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBAction func InstantiateTabBarController(_ sender: Any) {
        let TabBarViewController = storyboard!.instantiateViewController(withIdentifier: "TabBarController")
        
        present(TabBarViewController, animated: true, completion: nil)
    
    }
    
    let topMemeDelegate = MemeTextFieldDelegateClass()
    let bottomMemeDelegate = MemeTextFieldDelegateClass()
    

    
    var generatedMeme: UIImage?
    
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.00]
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
        
        imagePickerView.contentMode = .scaleAspectFit
        toolBar.contentMode = .scaleAspectFit
        navigationBar.contentMode = .scaleAspectFit
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
        /* This method is called by the "Share" Button in the upper left hand corner and
        it instantiates a UIActivityViewController */
        
        generatedMeme = generateMemedImage()
        
        
        let sharedActivityViewController = UIActivityViewController(activityItems: [generatedMeme as Any], applicationActivities: [])
        
        
        present(sharedActivityViewController, animated: true, completion: nil)
        
      sharedActivityViewController.completionWithItemsHandler = { (activity: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?)
        /* this a completionWithItemsHandler closure and calls the save() method */
        in
        
            self.save()
        }
    }
    
        
    @IBAction func callPickAnImageViewController(_ sender: Any) {
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
        
        if textField2.isFirstResponder {
            
            view.frame.origin.y = -(getKeyboardHeight(notification: notification))
            
            
        }
        
        
        
    
    }
    func keyboardWillHide(_ notification: Notification) {
        
        if textField2.isFirstResponder || (textField1.isFirstResponder && textField2.text! != "BOTTOM") {
            view.frame.origin.y = 0
        }
        
        
     
    }

    func getKeyboardHeight(notification: Notification) -> CGFloat {
        /* This function returns the height of the keyboard and it is called in the 
        above methods keyboardWillShow() and keyboardWillHide() */
        
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
        /* This function generates a memebed image by taking a screenshot */
        
        configureToolAndNavBars(isNotAvailable: true)
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        configureToolAndNavBars(isNotAvailable: false)
        
        
        return memedImage
    }
    func save() {
        // Create the meme
        let meme = Meme(topText: textField1.text!, bottomText: textField2.text!, originalImage: imagePickerView.image!, memedImage: generatedMeme!)
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
        
        appDelegate.memes.append(meme)
        

    }
    
    func configureTextField(textField:UITextField, withtext text: String, delegate: UITextFieldDelegate, textAttributes: [String:Any]) {
        /* This function configures the UITextFields displayed in the storyboard */
        
        textField.delegate = delegate
        textField.text! = text
        textField.defaultTextAttributes = textAttributes
        textField.textAlignment = .center
    }
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        /* the function instantiates a UIImagePickerController and passes
        the source type */
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
        
    }
    func configureToolAndNavBars(isNotAvailable: Bool) {
        /* This function turns the navigation and tool bars on/off 
        depending on the isNotAvailable Boolean */
        
        
        toolBar.isHidden = isNotAvailable
        navigationBar.isHidden = isNotAvailable
    }
    

}

