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

   @IBOutlet weak var tableView: UITableView! // Outlet to access table view from code
    
    var photoTakingHelper: PhotoTakingHelper? // creating a photoTaking helper object for when cam button is tapped
    var posts: [Post] = [] // To store the posts
    
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
 
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //1
        let followingQuery = PFQuery(className: "Follow")
        followingQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        
        //2
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery:followingQuery) // SubQuery to
        
        //3
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        //4 combining results from previous queries
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        //5
        query.includeKey("user") // why?
        //6
        query.orderByDescending("createAt")
        
        //7 network request
        query.findObjectsInBackgroundWithBlock{(result: [PFObject]?, error: NSError?) -> Void in
            //8
            self.posts = result as? [Post] ?? [] // nil coalescing - if the right hand side returns nil, replace it by empty array
            //9
            self.tableView.reloadData()
        }
    }
    
    }

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell")!
        cell.textLabel!.text = "Post"
        return cell
    }
}

    
    





