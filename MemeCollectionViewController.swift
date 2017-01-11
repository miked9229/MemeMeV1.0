//
//  MemeCollectionViewController.swift
//  Meme Me V1.0
//
//  Created by Michael Doroff on 1/7/17.
//  Copyright © 2017 Michael Doroff. All rights reserved.
//

import UIKit


class MemeCollectionViewController: UICollectionViewController {

    var memes: [Meme]!
    private let reuseIdentifier = "MemeCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes

    }



    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return  memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        
        
        // Configure the cell
        
        cell.labelTop!.text = meme.topText!
        cell.labelBottom!.text = meme.bottomText!
        cell.imageView!.image = meme.originalImage!
        
        return cell
    }
    
    
    @IBAction func CallMemeViewController(_ sender: Any) {
    
            
    let memeViewController = storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController")
            
    present(memeViewController, animated: true, completion: nil)
            
        
    
    }


}
