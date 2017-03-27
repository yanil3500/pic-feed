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

        // Do any additional setup after loading the view.
    }
    
    
    //Helper method that presents our image picker
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        
        //The class needs to conform to UIImagePickerControllerDelegate
        self.imagePicker.delegate = self
        
        
        //Source type specifies the type of picker interface to be displayed by the controller
        self.imagePicker.sourceType = sourceType
        
        //
        self.present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    //every view controller has the capability to dimiss itself
    //If user is presented with a cancel button, dismiss the image-picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func imageTapped(_ sender: Any) {
    }
}
