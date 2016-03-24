//
//  CaptureViewController.swift
//  Instagram
//
//  Created by Lawrence Chong on 3/15/16.
//  Copyright © 2016 Lawrence Chong. All rights reserved.
//

import UIKit
import Parse

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let vc = UIImagePickerController()
    var imageChanged = false
    var editedImage: UIImage?

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }
    
    @IBAction func onHome(sender: AnyObject) {
        self.performSegueWithIdentifier("camToHomeSegue", sender: nil)
    }
    
    @IBAction func onSignOut(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("camToLogOutSegue", sender: nil)
    }
    
    @IBAction func onUploadPhoto(sender: AnyObject) {
        self.choosePicture()
    }
    
    @IBAction func onPostPhoto(sender: AnyObject) {
        UserInfo.postUserImage(editedImage!, withCaption: captionField.text!, withCompletion: { (success, error) -> Void in
            if success == true {
                NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
            }
            else {
                print("\(error?.localizedDescription)")
            }
        })

        self.performSegueWithIdentifier("camToHomeSegue", sender: nil)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func choosePicture() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
        {
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else {
            print("No Photos")
        }
    }
    
    //Image picker controller delegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Change image to selected image
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            photoImage.contentMode = .ScaleAspectFit
            photoImage.image = pickedImage
        }
        
        // Get the image captured by the UIImagePickerController and resize it before saving
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Get half the size of the image
        let size = CGSize(width: originalImage.size.width / 2, height: originalImage.size.height / 2)
        editedImage = resize(originalImage, newSize: size)
        imageChanged = true
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Resize the image to make it use less memory
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
