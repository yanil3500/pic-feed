//
//  GalleryViewCell.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/29/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit

class GalleryViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var post: Post! {
        didSet {
            self.imageView.image = post.image
        }
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil 
    }
    
    
}
