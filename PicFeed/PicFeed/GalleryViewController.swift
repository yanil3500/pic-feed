//
//  GalleryViewController.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/29/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var galleryViewController: UICollectionView!
    
    var allPosts = [Post]() {
        didSet {
            self.galleryViewController.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.galleryViewController.dataSource = self
    }
}

//MARK: UICollectionViewDataSource Extension
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
}
