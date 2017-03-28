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
        
        self.imagePicker.allowsEditing = true
        
        //Source type specifies the type of picker interface to be displayed by the controller
        
        self.imagePicker.sourceType = sourceType
        self.present(self.imagePicker, animated: true, completion: nil)

        
        
    }
    
    //every view controller has the capability to dismiss itself
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
        print("Info: \(info[UIImagePickerControllerOriginalImage])")
        //The edited image is assigned to the imageView
        self.imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        if let capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //Saves captured image to photoAlbum
            UIImageWriteToSavedPhotosAlbum(capturedImage, self, nil, nil)
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                //Saves the edited image to photo album
                UIImageWriteToSavedPhotosAlbum(editedImage, self, nil, nil)
            }
        }

        //Dismisses picker controller
        imagePickerControllerDidCancel(picker)
        
    }
    @IBAction func imageTapped(_ sender: Any) {
        print("User has tapped image.")
        self.presentActionSheet()
    }
    
    @IBAction func postToPicFeed(_ sender: Any) {
        if let image = self.imageView.image {
            //Gets image from imageView
            let newPost = Post(image: image)
            
            CloudKit.shared.save(post: newPost, completion: { (success) in
                if success {
                    print("Saved post successfully to CloudKit!")
                } else {
                    print("Post was not saved successfully to CloudKit...")
                }
            })
        }
        print("POST has been tapped.")
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        //Checks to see if there is an image on t
        guard let image = self.imageView.image else { return }
        let alertController = UIAlertController(title: "Title", message: "Please selected a filter", preferredStyle: .alert)
        
        let blackAndWhiteAction = UIAlertAction(title: "Black & White", style: .default) { (action) in
            <#code#>
        }
        
        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
            <#code#>
        }
        let resetAction = UIAlertAction(title: "Reset Image", style: .destructive) { (action) in
            <#code#>
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(blackAndWhiteAction)
        alertController.addAction(vintageAction)
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    //the following function asks the user for permissions in regards to camera use and 
    
    func presentActionSheet(){
        /*
         An action sheet is a specific style of alert that appears in response to a control or action, and presents a set of two or more choices related to the current context. Use an action sheet to let people initiate tasks, or to request confirmation before performing a potentially destructive operation. */
        let actionSheetController = UIAlertController(title: "Source", message: "Please select source type", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .camera)
        }
        
        //If the application is launched on a device without a camera, the camera option is disabled but shown (grayed out); Indicating to the user that the camera option would be available if his or her device supported it.
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAction.isEnabled = false
        }
            
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        //Attaches action object to the action sheet
        
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoAction)
        actionSheetController.addAction(cancelAction)
        
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
}
