//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Lena Ngungu on 6/29/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit


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
    
extension TimelineViewController: UITabBarControllerDelegate
{
    
    func takePhoto()
    {
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!, callback: {(image: UIImage?) in print("received a callback")})
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





