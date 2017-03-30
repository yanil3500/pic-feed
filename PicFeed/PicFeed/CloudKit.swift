//
//  CloudKit.swift
//  PicFeed
//
//  Created by Elyanil Liranzo Castro on 3/27/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

import CloudKit
import UIKit


typealias SuccessCompletion = (Bool) -> ()

//fetches an array of posts from iCloud
typealias PostsCompletion = ([Post]?) -> ()

class CloudKit {

    
    static let shared = CloudKit()
    
    private init (){}
    
    //Gives us an access point to the container specified in the capabilities pane
    let container = CKContainer.default()
    
    var privateDB : CKDatabase {
        return self.container.privateCloudDatabase
    }
    
    func save(post: Post, completion: @escaping SuccessCompletion){
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
                        print("Inside of CloudKit.shared.save: \(record)")
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
    
    func getPosts(completion: @escaping PostsCompletion){
        /*In CloudKit, there is CKQuery object. Before querying CloudKit,
         an instance of CKQuery has to be created so that it can do the query for us*/
        
        let postQuery = CKQuery(recordType: "Post", predicate: NSPredicate(value: true))
        
        print("Inside of getPosts: ")
        self.privateDB.perform(postQuery, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
            
            guard let records = records else { fatalError("Failed to get records.") }
            
            var posts = [Post]()
                
            for record in records {
                
                guard let asset = record["image"] as? CKAsset else { fatalError("Failed to get asset.") }
                
                let path = asset.fileURL.path
                
                guard let dateCreated = record.creationDate else { fatalError("Failed to get date.") }

                
                guard let image = UIImage(contentsOfFile: path) else { fatalError("Failed to get image.") }
                
                let newPost = Post(image: image)
                
                newPost.dateCreated = dateCreated
                
                posts.append(newPost)
                
                print("Inside of getPosts: \(newPost)")
            }
            
            OperationQueue.main.addOperation {
                completion(posts)
            }
        }
    }
        
        
        
        
        
        
        
        
}

