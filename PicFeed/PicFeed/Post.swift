//
//  Post.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/28/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit
import CloudKit
//Posting images to iCloud
//Images first have to be converted to raw data and written to the disk
//The data that is written to disk is what is transmitted to iCloud


class Post {
    let image : UIImage
    
    init(image: UIImage) {
        self.image = image
    }
}

enum PostError : Error {
    //If there is an error taking to UIImage to rawData
    case WritingImageToData
    case writingDataToDisk
}

extension Post {
    
    //Retrieves the CKRecord for a given Post
    class func recordFor(post: Post) throws -> CKRecord? {
        
        //the first parameter is the image that is to be converted, the second parameter is the compression setting for the image
        //UIImageJPEGRepresentation convert the UIImage to raw data, preparing the data for CKRecord 
        guard let data = UIImageJPEGRepresentation(post.image, 0.7) else {
            //If image to data conversion fail, throw PostError.WritingImageToData
            throw PostError.WritingImageToData
        }
        
        do {
            try data.write(to: post.image.path)
            //Create an asset; Stores raw data (image, video, audio) into a CKAsset
            
            //Retrieves the image stored in the directory specified by the path
            let asset = CKAsset(fileURL: post.image.path)
            
            //Tells CloudKit to create a new record of type 'Post' in the cloud
            let record = CKRecord(recordType: "Post")
            record.setValue(asset, forKey: "image")
            
            
            return record
        } catch {
            throw PostError.writingDataToDisk
        }
        
        return nil
    }
}
