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
    
    @IBOutlet weak var dateCreated: UILabel!
    var datePosted: String = ""
    var post: Post! {
        didSet {
            self.imageView.image = post.image
            self.datePosted = Post.getDate(dateTo: post.dateCreated!)
        }
    }
    
    //Accounts for bugs in reusing cells (Ex: Retrieving images asynchronously; reuse the cell without clear, resulting in the new image beign stack on top of the old image)
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.imageView.image = nil
        self.datePosted = ""
    }
    
    
}
