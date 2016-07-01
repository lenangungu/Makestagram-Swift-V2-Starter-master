//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by Lena Ngungu on 6/29/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

// enable the function signature UIImage? -> void to be mentionned as PhotoTakingHelperCallback
// a typealias has to be a global variable
//the callback function will need to tak in an UIImage and returne nothing

typealias PhotoTakingHelperCallback = UIImage? -> Void // Void or ()


//This class will present the action of either taking a photo or selecting it from the library. It will also receive the photo and presents it
class PhotoTakingHelper: NSObject {
    
//Creating a "view controller" to show option when photo icon is clicked, and where photo is presented
    
    //variables to be passed when PhotoTakingHelper is called 
    //the callback is a block of code to be executed once this class is called
    
    weak var viewController: UIViewController! //view controller used to display photo
    var callback: PhotoTakingHelperCallback // function to be called after user receives an image
    var imagePickerController: UIImagePickerController?
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType)
    {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self // imagePickerController is now the delegate of the UIImageViewController- it will display picture
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
    
    
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback)
    {
        self.viewController = viewController
        self.callback = callback
        super.init()
        showPhotoSourceSelection() // in initializer, therefor will be called as soon as photo button pressed (create an object of PhotoTakingHelper)
    }
    
    
    func showPhotoSourceSelection()
    {
        let alertController = UIAlertController(title: nil, message: "Where do you wnat to get your picture from ?", preferredStyle: .ActionSheet )
        
        //UIAlertAction
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil )
        alertController.addAction(cancelAction) // add cancel action to almost all alert controller
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) {(action) in
             self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction) // adding created action to alert action will include phto taking from library button
        
        //show camera option only if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear))
        {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) {(action) in
                self.showImagePickerController(.Camera) //???
            }
            alertController.addAction(cameraAction)
        }

      viewController.presentViewController(alertController, animated: true, completion: nil)
       
}
    
}

//MARK: Extension (are always outside of class definition

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    //: editingInfo is a dictionary
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: AnyObject]!){
    viewController.dismissViewControllerAnimated(false, completion: nil)
        
    callback(image)
    
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)//dismissing cancel button as we are now delegate of the imagePickerViewController
        
    }
}



//: Things I will review
//: external names // dictionaries // closures // callbacks



















