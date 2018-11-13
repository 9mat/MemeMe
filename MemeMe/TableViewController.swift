//
//  TableViewController.swift
//  MemeMe
//
//  Created by dhlong on 30/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    lazy var addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
    
    @objc func addNewMeme() {
        print("click add")
        self.performSegue(withIdentifier: "addNewMeme", sender: self)
    }
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return memes.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:  .default, reuseIdentifier: "MemeCell")
//        let meme = memes[indexPath.row]
//        cell.imageView?.image = meme.memedImage
//        cell.textLabel?.text = "\(meme.topText ?? "")\(meme.bottomText ?? "")"
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = addButtonItem
    }
}
