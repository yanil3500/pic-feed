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
        self.galleryViewController.collectionViewLayout = GalleryCollectionViewLayoutController(columns: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
    }
    
    func update(){
        CloudKit.shared.getPosts { (posts) in
            guard let posts = posts else { fatalError("Failed to get posts.") }
            self.allPosts = posts
        }
    }
}

//MARK: UICollectionViewDataSource Extension
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryViewCell.identifier, for: indexPath) as! GalleryViewCell
        
        cell.post = self.allPosts[indexPath.row]
        
        var title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
        
        title.backgroundColor = UIColor.white
        title.text = "Posted: \(cell.datePosted)"
        title.numberOfLines = 0
        cell.contentView.addSubview(title)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
}
