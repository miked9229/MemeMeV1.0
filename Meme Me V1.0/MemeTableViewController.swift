//
//  MemeTableViewController.swift
//  Meme Me V1.0
//
//  Created by Michael Doroff on 1/7/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import UIKit
import Foundation


class MemeTableViewController: UITableViewController {

    var memes: [Meme]!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        // Do any additional setup after loading the view.
    }
    @IBAction func callMemeViewController(_ sender: Any) {
    let memeViewController = storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController")
            
    present(memeViewController, animated: true, completion: nil)
            
        }
    
    
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = (meme.topText!) + (meme.bottomText!)
        cell.imageView?.image = meme.memedImage!
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }

}
