//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Lena Ngungu on 6/29/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {

    var photoTakingHelper: PhotoTakingHelper? // creating a photoTaking helper object for when cam button is tapped
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //making the timeline VC its own delegate
        self.tabBarController?.delegate = self

        // Do any additional setup after loading the view.
    }

}

    //protocol method- making the timeLine VC the delegate of the tabBar

// MARK: Tab Bar Delegate
    
extension TimelineViewController: UITabBarControllerDelegate // the TimeLineViewController is the delegate of the TabBarController
{
    
    func takePhoto()
    {
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!, callback: {(image: UIImage?) in
            let post = Post()
            post.image = image
            post.uploadPost()
            
/* the code above replaced this code after the "Post" custom class was created and linked to swift
             
             if let image = image {
                let imageData = UIImageJPEGRepresentation(image, 0.8)! // returning image as jpg, passing a compression constant because a PFFile takes in NSData (jpg)
             
                let imageFile = PFFile(name: "image.jpg", data: imageData )! // A PFFile takes a name and image data
             
                print(imageFile.name) //- test if code works
             
                let post = PFObject(className: "Post") // creating a post from the post class
                post["imageFile"] = imageFile // the post called imageFile is being filled with the file in which we passed the image
                post.saveInBackground() // Saving image
 */
            
        })
    }
     // Keyword "in" marks the begining of the code in a closure; closure will be called after PhotoHelper has received an image
        
    func tabBarController(tabBarController: UITabBarController ,shouldSelectViewController viewController: UIViewController) -> Bool
        {
            if (viewController is PhotoViewController)
            {
                takePhoto()
                return false
            }
                
            else
            {
                return true
            } //tab behaves as usual and display the VC clicked on
        }
 
    }





