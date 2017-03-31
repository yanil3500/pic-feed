//
//  FilterCell.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/30/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    

    @IBOutlet weak var filterIdentifier: UILabel!
    var filter : FilterName?
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.filter = nil 
        self.imageView.image = nil
    }
}
