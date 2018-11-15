//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by dhlong on 14/11/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

//
//  TableViewController.swift
//  MemeMe
//
//  Created by dhlong on 30/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit


class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
}


class CollectionViewController: UICollectionViewController {
    @IBOutlet var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    lazy var addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMeme))
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        print("meme count = \(memes.count), index = \(indexPath.item), cell = \(String(describing: cell.memeImageView))")
        cell.memeImageView.image = memes[indexPath.item].memedImage
        return cell

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.item]
        let memeViewController = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        memeViewController.meme = meme
        navigationController!.pushViewController(memeViewController, animated: true)
    }
    
    @objc func addNewMeme() {
        self.performSegue(withIdentifier: "addNewMeme", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = addButtonItem
        
        let space:CGFloat = 3.0
        let dimension = view.frame.size.width/3.0 - (4*space)
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeCollectionView.reloadData()
//        memeTableView.reloadData()
//        memeTableView.allowsSelection = true
//        memeTableView.isUserInteractionEnabled = true
//        memeTableView.delegate = self
    }
    
}
