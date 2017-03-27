//
//  CloudKit.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/27/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import CloudKit
import Foundation

class CloudKit {
    
    static let shared = CloudKit()
    
    private init (){}
    
    //Gives us an access point to the container specified in the capabilities pane
    let container = CKContainer.default()
    
    var privateDB : CKDatabase {
        return self.container.privateCloudDatabase
    }
}
