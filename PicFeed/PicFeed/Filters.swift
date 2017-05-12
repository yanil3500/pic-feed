//
//  Filters.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/28/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import UIKit
import CoreImage

//The enum allows us to give a more meaningful identifier to the underlying string representations of the image filters
enum FilterName : String {
    case Vintage = "CIPhotoEffectTransfer"
    case BlackAndWhite = "CIPhotoEffectMono"
    case Posterize = "CIColorPosterize"
    case CircularWrap = "CICircularWrap"
    case ComicEffect = "CIComicEffect"
    
}

typealias FilterCompletion = (UIImage?) -> ()

class Filters {
    
    static let shared = Filters()
    
    private init () {}
    //Hold reference to th original image
    static var originalImage = UIImage()
    
    static var undoImageFilters = [UIImage]()
    
    static var filterNames = [FilterName.Vintage : "Vintage" , FilterName.BlackAndWhite : "Black & White", FilterName.Posterize : "Posterize", FilterName.CircularWrap : "Circular Wrap", FilterName.ComicEffect : "Comic Effect"]
    
    class func filter(name: FilterName, image: UIImage, completion: @escaping FilterCompletion){
        OperationQueue().addOperation {
            
            guard let filter = CIFilter(name: name.rawValue) else { fatalError("Invalid CI filter.") }
            
            //Gets CI Image 
            let coreImage = CIImage(image: image)
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            
            //GPU Context 
            let options = [kCIContextWorkingColorSpace : NSNull()]
            guard let eaglContext = EAGLContext(api: .openGLES2) else { fatalError("Failed to create EAGL context.") }
            let ciContext = CIContext(eaglContext: eaglContext, options: options)
            
            //Get final image using GPU
            
            guard let outputImage = filter.outputImage else { fatalError("Failed to get output image from filter.") }
            
            if let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) {
                let finalImage = UIImage(cgImage: cgImage)
                
                OperationQueue.main.addOperation {
                    completion(finalImage)
                }
                
            } else {
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
            
        }
    }
}
