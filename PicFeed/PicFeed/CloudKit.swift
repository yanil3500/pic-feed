//
//  CloudKit.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/27/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import CloudKit
import Foundation


typealias PostCompletion = (Bool) -> ()
class CloudKit {

    
    static let shared = CloudKit()
    
    private init (){}
    
    //Gives us an access point to the container specified in the capabilities pane
    let container = CKContainer.default()
    
    var privateDB : CKDatabase {
        return self.container.privateCloudDatabase
    }
    
    func save(post: Post, completion: @escaping PostCompletion){
        do {
            if let record = try Post.recordFor(post: post) {
                
                privateDB.save(record, completionHandler: { (record, error) in
                    
                    //Means saving to privateDb was unsuccessful
                    if error != nil {
                        completion(false)
                        //The return statement will prevent the execution from falling through to the bottom of the conditional to the rest of the statements in the codeblock
                        return
                    }
                    
                    //If there is a record, it means a record was posted to iCloud
                    if let record = record {
                        print(record)
                        completion(true)
                    } else {
                    //If there isn't a record and there isn't an error
                        completion(false)
                    }
                })
            }
        } catch {
            print(error)
        }
    }
}
