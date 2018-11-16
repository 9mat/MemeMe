//
//  MemeDetailImageView.swift
//  MemeMe
//
//  Created by dhlong on 15/11/18.
//  Copyright © 2018 Udacity. All rights reserveds.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        if let meme = meme {
            memeDetailImageView.image = meme.memedImage
        }
    }
}
