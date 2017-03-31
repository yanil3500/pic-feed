//
//  GalleryViewController.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/29/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit

protocol GalleryViewControllerDelegate : class {
    func galleryController(didSelect image: UIImage)
}

class GalleryViewController: UIViewController {
    
    weak var delegate : GalleryViewControllerDelegate?
    

    @IBOutlet weak var galleryViewController: UICollectionView!

    var allPosts = [Post]() {
        didSet {
            self.galleryViewController.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.galleryViewController.delegate = self
        self.galleryViewController.dataSource = self
        self.galleryViewController.collectionViewLayout = GalleryCollectionViewLayoutController(columns: 2)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        update()
    }

    func update() {
        CloudKit.shared.getPosts { (posts) in
            guard let posts = posts else { fatalError("Failed to get posts.") }
            self.allPosts = posts
        }
    }
    
    @IBAction func userPinched(_ sender: UIPinchGestureRecognizer) {
        //collectionView.collectionViewLayout as? GalleryCollectionLayout else {return}
        
        guard let layout = galleryViewController.collectionViewLayout as? GalleryCollectionViewLayoutController else { return }
        switch sender.state {
        case .began:
            print("User pinched.")
        case .changed:
            print("<---User pinch changed--------->")
        case .ended:
            print("Pinch ended.")
            let columns = sender.velocity > 0 ? layout.columns - 1 : layout.columns + 1
            
            if columns < 1 || columns > 10 { return }
            
            galleryViewController.setCollectionViewLayout(GalleryCollectionViewLayoutController(columns: columns), animated: true)
            
        default:
            print("Unknown sender state")
        }
        
    }
    
    
}





// MARK: UICollectionViewDataSource Extension
extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewCell.identifier, for: indexPath) as! GalleryViewCell

        cell.post = self.allPosts[indexPath.row]

        cell.dateCreated.text = cell.datePosted

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = self.delegate else { return }
        
        let selectedPost = self.allPosts[indexPath.row]
        
        delegate.galleryController(didSelect: selectedPost.image)
    }
}
