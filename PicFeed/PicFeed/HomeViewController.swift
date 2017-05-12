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
    
    let animationDuration = 0.4
    
    let constraints = 8
    
    @IBOutlet weak var filterButtonTopConstraint: NSLayoutConstraint!
    //DONE: Have at least 2 or more constraint-based animations in your UI. Choose whichever constraints you'd like, be creative.
    @IBOutlet weak var postButtonBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = #imageLiteral(resourceName: "Twitter_Logo_White_On_Image")
        // Do any additional setup after loading the view.
        
        postButtonBottomConstraint.constant = CGFloat(constraints)
        filterButtonTopConstraint.constant = CGFloat(constraints)
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    //Helper method that presents our image picker
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        
        //The class needs to conform to UIImagePickerControllerDelegate
        self.imagePicker.delegate = self
        //Source type specifies the type of picker interface to be displayed by the controller
        
        self.imagePicker.sourceType = sourceType
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    //every view controller has the capability to dismiss itself
    //If user is presented with a cancel button, dismiss the image-picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //tells the delegate that the user picked a still image or movie (see info dictionary)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //The edited image is assigned to the imageView

        guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        self.imageView.image = originalImage
        
        
        //Sets the originalImage property on Filters class
        
        Filters.originalImage = originalImage
        
        //Dismisses picker controller
        imagePickerControllerDidCancel(picker)
        
    }
    @IBAction func imageTapped(_ sender: Any) {
        print("User has tapped image.")
        self.presentActionSheet()
    }
    
    @IBAction func postToPicFeed(_ sender: Any) {
        if let image = self.imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
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
    
    func filterAlertGenerator(enumCase: FilterName, title: String)-> UIAlertAction {
        guard let image = self.imageView.image else { fatalError("Could not get image.") }
        let filterAction = UIAlertAction(title: title, style: .default) { (action) in
            Filters.filter(name: enumCase, image: image, completion: { (filteredImage) in
                guard let filteredImageUnwrapped = filteredImage else { fatalError("Image failed to safely unwrap.") }
                //Adds filtered image to separate array for undo action
                Filters.undoImageFilters.append(filteredImageUnwrapped)
                //Update image view
                self.imageView.image = filteredImageUnwrapped
            })
        }
        
        return filterAction
    }
    
    func undoAction() -> UIAlertAction {
        let undoAction = UIAlertAction(title: "Undo Filter", style: .destructive) { (action) in
            if Filters.undoImageFilters.count > 0 {
                if self.imageView.image == Filters.undoImageFilters.last {
                    Filters.undoImageFilters.removeLast()
                }
                self.imageView.image = Filters.undoImageFilters.popLast()
            } else {
                self.imageView.image = Filters.originalImage
            }
        }
        return undoAction
    }
    
    
    @IBAction func filterButtonTapped(_ sender: Any) {

        let alertController = UIAlertController(title: "PicFeed", message: "Please select a filter", preferredStyle: .alert)
        
        Filters.filterNames.map { (key: FilterName, title: String) -> UIAlertAction in
            filterAlertGenerator(enumCase: key, title: title)
        }.forEach { (filterAction) in
            alertController.addAction(filterAction)
        }
        
        
        let resetAction = UIAlertAction(title: "Reset Image", style: .destructive) { (action) in
            self.imageView.image = Filters.originalImage
            Filters.undoImageFilters.removeAll()
            print("Number of filtered photos (after reset): \(Filters.undoImageFilters.count)")
        }
        let saveAction = UIAlertAction(title: "Save Image", style: .default) { (action) in
            guard let imageOnView = self.imageView.image else { return }
            UIImageWriteToSavedPhotosAlbum(imageOnView, self, nil, nil)
        }
  

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(undoAction())
        alertController.addAction(resetAction)
        alertController.addAction(saveAction)
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
