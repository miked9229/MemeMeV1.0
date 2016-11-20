//
//  ViewController.swift
//  Meme Me V1.0
//
//  Created by Michael Doroff on 11/18/16.
//  Copyright © 2016 Michael Doroff. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField1: UITextField!
    
    let topMemeDelegate = MemeTextFieldDelegateClass()
    let bottomMemeDelegate = MemeTextFieldDelegateClass()
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.00]
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField1.delegate = topMemeDelegate
        textField2.delegate = bottomMemeDelegate
        textField1.defaultTextAttributes = memeTextAttributes
        textField2.defaultTextAttributes = memeTextAttributes
        textField1.textAlignment = .center
        textField2.textAlignment = .center
        textField1.text = "TOP"
        textField2.text = "BOTTOM"

    
    }
    


    @IBAction func callPickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    
        
    
    
    
    }

    @IBAction func callPickAnImageViewController(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    
    
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print(image)
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }

    }
}

