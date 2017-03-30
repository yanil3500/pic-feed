//
//  GalleryCollectionViewLayoutController.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/29/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit

class GalleryCollectionViewLayoutController: UICollectionViewFlowLayout {
    
    var columns = 2
    
    let spacing : CGFloat = 1.0
    
    var screenWidth : CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var itemWidth : CGFloat {
        let availableScreen = screenWidth - (CGFloat(self.columns) * self.spacing)
        return availableScreen / CGFloat(self.columns)
    }
    
    init(columns : Int = 2) {
        self.columns = columns
        
        super.init()
        
        //The parent class initializer has to be called in the middle so that we can modify the default properties that it initializes
        
        self.minimumLineSpacing = spacing
        self.minimumInteritemSpacing = spacing
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
