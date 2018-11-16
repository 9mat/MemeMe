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
        
    @IBOutlet weak var memeTableView: UITableView!
    
    @objc func addNewMeme() {
        self.performSegue(withIdentifier: "addNewMeme", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewMeme" {
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:  .default, reuseIdentifier: "MemeCell")
        let meme = memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topText ?? "") \(meme.bottomText ?? "")"
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = memes[indexPath.row]
        navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeTableView.reloadData()        
        memeTableView.delegate = self
    }
    
}
