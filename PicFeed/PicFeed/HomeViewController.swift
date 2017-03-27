//
//  HomeViewController.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/27/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = #imageLiteral(resourceName: "Twitter_Logo_White_On_Image")
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    //Helper method that presents our image picker
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        
        //The class needs to conform to UIImagePickerControllerDelegate
        self.imagePicker.delegate = self
        
        
        //Source type specifies the type of picker interface to be displayed by the controller
        
        self.imagePicker.sourceType = sourceType
        self.present(self.imagePicker, animated: true, completion: nil)

        
        
    }
    
    //every view controller has the capability to dimiss itself
    //If user is presented with a cancel button, dismiss the image-picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func getImageFromPhotoLibrary(photoDic: [String: Any]) -> UIImageView {
//        guard let imageUrl = photoDic["UIImagePickerControllerOriginalImage"] as? String else { fatalError("Cannot get image url") }
//        
//        
//    }
    
    //tells the delegate that the user picked a still image or movie (see info dictionary)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Info: \(info["UIImagePickerControllerOriginalImage"])")
        self.imageView.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        
        //Dismisses picker controller
        imagePickerControllerDidCancel(picker)
    }
    @IBAction func imageTapped(_ sender: Any) {
        print("User has tapped image.")
        self.presentActionSheet()
    }
    
    func doesHaveCamera() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    

    
    //the following function asks the user for permissions in regards to camera use and 
    
    func presentActionSheet(){
        /*
         An action sheet is a specific style of alert that appears in response to a control or action, and presents a set of two or more choices related to the current context. Use an action sheet to let people initiate tasks, or to request confirmation before performing a potentially destructive operation. */
        let actionSheetController = UIAlertController(title: "Source", message: "Please select source type", preferredStyle: .actionSheet)
        
        if doesHaveCamera() {
          let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .camera)
          }
            actionSheetController.addAction(cameraAction)
        }
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        //Attaches action object to the action sheet
        
        actionSheetController.addAction(photoAction)
        actionSheetController.addAction(cancelAction)
        
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
}
