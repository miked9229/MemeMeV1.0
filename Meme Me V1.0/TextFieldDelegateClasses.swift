//
//  TextFieldDelegateClasses.swift
//  Meme Me V1.0
//
//  Created by Michael Doroff on 11/20/16.
//  Copyright © 2016 Michael Doroff. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegateClass: NSObject, UITextFieldDelegate  {

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
          var newText = textField.text! as NSString
        
          newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text == "TOP" || text == "BOTTOM" {
                textField.text = ""
                
            }
        }
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // figure out when this method should be called.
        textField.resignFirstResponder()
        return true
    
    }

}

