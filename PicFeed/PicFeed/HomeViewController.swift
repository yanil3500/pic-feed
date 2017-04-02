//
//  HomeViewController.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/27/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit
import Social

class HomeViewController: UIViewController {

    let imagePicker = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    let animationDuration = 0.4
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionViewHeight.constant = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = #imageLiteral(resourceName: "Twitter_Logo_White_On_Image")
        // Do any additional setup after loading the view.

        self.collectionView.dataSource = self
        
        self.collectionView.delegate = self
        
        setupGalleryDelegate()

    }
    
    func setupGalleryDelegate(){
        if let tabbarController = self.tabBarController {
            
            guard let viewController = tabbarController.viewControllers else { return }
            
            guard let galleryController = viewController[1] as? GalleryViewController else { return }
            
            galleryController.delegate = self
            
        }
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
    
    @IBAction func userLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            guard let composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else { return }
            
            composeController.add(self.imageView.image)
            
            self.present(composeController, animated: true, completion: nil)
        }

    }

    func undoAction() -> UIAlertAction {
        let undoAction = UIAlertAction(title: "Undo Filter", style: .destructive) { (_) in
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

    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    @IBAction func filterButtonTapped(_ sender: Any) {

        print("filter button tapped")
        
        
        collectionViewHeight.constant = 150
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }


    }

    //the following function asks the user for permissions in regards to camera use and 

    func presentActionSheet() {
        /*
         An action sheet is a specific style of alert that appears in response to a control or action, and presents a set of two or more choices related to the current context. Use an action sheet to let people initiate tasks, or to request confirmation before performing a potentially destructive operation. */
        let actionSheetController = UIAlertController(title: "Source", message: "Please select source type", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.presentImagePickerWith(sourceType: .camera)
        }

        //If the application is launched on a device without a camera, the camera option is disabled but shown (grayed out); Indicating to the user that the camera option would be available if his or her device supported it.
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAction.isEnabled = false
        }

        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
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

// MARK: UICollectionViewDataSource for filterCell
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as! FilterCell

        guard let originalImage = Filters.originalImage else { return filterCell }

        guard let resizedImage = originalImage.resize(size: CGSize(width: 50, height: 50)) else { return filterCell }

        let filterName = Filters.filterNames.keys.map({ (filterName) -> FilterName in
            filterName
        })[indexPath.row]
        
        //Assign filter to filterCell
        
        filterCell.filter = filterName
        
        let filterIdentifier = Filters.filterNames.values.map({ (filterIdentifier) -> String in
            filterIdentifier
        })[indexPath.row]
        
        filterCell.filterIdentifier.text = filterIdentifier
            
        Filters.shared.filter(name: filterName, image: resizedImage) { (filteredImage) in
            filterCell.imageView.image = filteredImage
        }

        return filterCell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Filters.filterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterName = Filters.filterNames.keys.map({ (filterName) -> FilterName in
            filterName
        })[indexPath.row]
        
        print("Filtering: ")
        Filters.shared.filter(name: filterName, image: Filters.originalImage!, completion: { (filteredImage) in
            self.imageView.image = filteredImage
        })
    }
    
    
    
    
    
}

extension HomeViewController: GalleryViewControllerDelegate {
    func galleryController(didSelect image: UIImage) {
        
        Filters.originalImage = image 
        self.imageView.image = image
        
        self.tabBarController?.selectedIndex = 0
        
        
    }
}

//MARK: UIImagePickerControllerDelegate
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //Helper method that presents our image picker
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        
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
        
        self.collectionView.reloadData()
        
        //Dismisses picker controller
        imagePickerControllerDidCancel(picker)
        
    }

}
