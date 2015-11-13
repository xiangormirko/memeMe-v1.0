//
//  MemeDetailView.swift
//  MemeMe v.01
//
//  Created by MIRKO on 11/11/15.
//  Copyright © 2015 XZM. All rights reserved.
//

import Foundation

import UIKit

class MemeDetailViewController: UIViewController{

    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        
        self.imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
}