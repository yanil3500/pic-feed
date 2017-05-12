//
//  UIExtensions.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/28/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resize(size: CGSize) -> UIImage? {
        //Creates a graphics context
        UIGraphicsBeginImageContext(size)
        
        //Self is an instance of UIImage
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        //UIGraphicsGetImageFromCurrentImageContext() gets the image from the self.draw
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    
        
        return resizedImage
    }
    
    
    //Gets path of the image that was converted to raw data
    
    var path: URL {
        //Represents file path and file structure of application
        
        //FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first will return the first url
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Error getting documents directory")
        }
        //Get documentsDirectory, creates a subdirectory called image, where all the images will be stored
        return documentsDirectory.appendingPathComponent("image")
    }
}

extension UIResponder {
    static var identifier : String {
        return String(describing: self) 
    }
}
