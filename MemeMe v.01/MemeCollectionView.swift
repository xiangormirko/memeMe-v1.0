//
//  MemeCollectionView.swift
//  MemeMe v.01
//
//  Created by MIRKO on 11/12/15.
//  Copyright © 2015 XZM. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make collection items responsive in size and position
        
        let space: CGFloat = 3.0
        let dimensionW = (self.view.frame.size.width - (2 * space)) / 3.0
        let dimensionH = (self.view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimensionW, dimensionH)

    }
    
    override func viewWillAppear(animated: Bool) {
        // reloading table data after change
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //deque and use cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.memeImageView.contentMode = UIViewContentMode.ScaleAspectFit
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.memeImageView?.image = meme.memedImage
        //cell.schemeLabel.text = "Scheme: \(villain.evilScheme)"
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // present detail view when a cell is pressed
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    

    
    
}