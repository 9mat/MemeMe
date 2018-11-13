//
//  ViewController.swift
//  MemeMe
//
//  Created by dhlong on 29/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit


struct Meme {
    let topText: String?
    let bottomText: String?
    let originalImage: UIImage?
    let memedImage: UIImage?
}

class MemeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolbar: UIToolbar!

    lazy var shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))

    // a variable to hold the generated meme
    var meme: Meme!
    
    let topTextFieldDelegate = MemeTextFieldDelegate()
    let bottomTextFieldDelegate = MemeTextFieldDelegate()
    
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -2.0]
    
    func configureMemeTextField(textField: UITextField, text: String, delegate: MemeTextFieldDelegate) {
        textField.text = text
        textField.delegate = delegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        configureMemeTextField(textField: topTextField, text: "TOP", delegate: topTextFieldDelegate)
        configureMemeTextField(textField: bottomTextField, text: "BOTTOM", delegate: bottomTextFieldDelegate)
        shareButtonItem.isEnabled = false
        
        navigationItem.rightBarButtonItem = shareButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // subscribe to be notified when keyboard appear
        // so that we can adjust the image and bottom text accordingly
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(sourceType: .camera)
    }
    
    //MARK: - Delegates
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imagePickerView.image = image
        dismiss(animated:true, completion: nil)
        shareButtonItem.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: handling keyboard when editing the bottom text
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let keyboardSize = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        // when chaning text on the bottom text field, shift the image view up
        // so that the keyboard does not hide the text field
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: sharing and saving

    
    func generateMemedImage() -> UIImage {
        // hide the toolbar and navigation bar so that they will not appear in the meme
        toolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // show the tool bar and the navigation bar again
        toolbar.isHidden = false

        return memedImage
    }
    
    
    func save(_ memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imagePickerView.image, memedImage: memedImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        UIImageWriteToSavedPhotosAlbum(meme.memedImage!, self, nil, nil)
    }

    @IBAction func shareMeme(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let shareViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // set up a handler to save the meme to album after finishing sharing
        shareViewController.completionWithItemsHandler = {
            (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            
            // no saving if user cancels photo sharing
            if !completed {
                return
            }
            
            // save photo to photo library
            self.save(memedImage)
        }
        
        present(shareViewController, animated: true, completion: nil)
        
        // on iPad, UIActivityViewController must configure `popoverPresentationController` by providing either a sourceView and sourceRect or a barButtonItem
        // see https://medium.com/@dushyant_db/how-to-present-uiactivityviewcontroller-on-iphone-and-ipad-ae72013d2a5a
        if let popOver = shareViewController.popoverPresentationController {
            popOver.sourceView = self.view
        }
    }
    @IBAction func backToTabView(_ sender: Any) {
        if let navigationController = navigationController {
            print("navigating back")
            navigationController.popToRootViewController(animated: true)
        }
    }
}

