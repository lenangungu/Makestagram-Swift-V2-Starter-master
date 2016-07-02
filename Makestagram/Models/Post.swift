//
//  Post.swift
//  Makestagram
//
//  Created by Lena Ngungu on 6/30/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

// Parse custom classes need 1) to inherit from PFObject, and 2) to implement the PFSubclassing protocol
// The post class extends PFObject so that we can use . to access our variables
//PFuser and PFFiles are specific to Parse 
//PFUser and PFFile are types

class Post: PFObject, PFSubclassing {
    
    // Properties to be accessed in this Parse class
    @NSManaged var imageFile: PFFile? //@NSManaged variables are runing time variables; these won't be initialized in the initializer
    
    @NSManaged var user: PFUser?
    var image: UIImage?
    
    var photoUploadTask: UIBackgroundTaskIdentifier? // creating a background task to request a long running background task
    
    // MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String // Estblishing a connection between the Parse ans Swift "Post class"
    {
        return "Post"

    }
    override init() // Should be in any Parse custom class
    {
        super.init()
    }
   
    override class func initialize() //Should be in any Parse custom class
    {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken)
        {
            self.registerSubclass()
        }
    }
//    
//    func uploadPost()
//    {
//        if let image = image
//        {
//            let imageData = UIImageJPEGRepresentation(image, 0.8)!
//            let imageFile = PFFile(name: "image.jpg", data: imageData)!
//            self.imageFile = imageFile
//            saveInBackground()
//            
//        }
//    }
//    func uploadPost() {
//        if let image = image {
//            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
//            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
//            
//        user = PFUser.currentUser() // assinging the currently logged in user to the "Post" class property
//            self.imageFile = imageFile
//            saveInBackgroundWithBlock(nil) //this function allows us to pass a callback hich in this case we do not need
//       // }
    //}

func uploadPost() {
    if let image = image {
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
        guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
        
        // any uploaded post should be associated with the current user
        user = PFUser.currentUser()
        self.imageFile = imageFile
        
        // 1
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        } // passing a closure in case the expiration time is up, calling UIApplication.sharedApplication().endBackgroundTask to make sure the app doesnt terminate when the time expires.
        
        // 2
        saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
            // 3
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!) //marks ending of the long running operation
        }
    }


    }
}
