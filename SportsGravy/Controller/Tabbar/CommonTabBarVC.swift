//
//  CommonTabBarVC.swift
//  SportsGravy
//
//  Created by CSS on 25/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class CommonTabBarVC: UITabBarController, sidemenuDelegate, UITabBarControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imageviewcontroller = UIImagePickerController()

    
    
    func sidemenuselectRole(role: String, roleArray: NSMutableArray) {
        print("delegate")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
         self.delegate = self
                if revealViewController() != nil {
                            revealViewController().rearViewRevealWidth = self.view.frame.size.width - 70
                            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                            }
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let indexOfTab = tabBar.items?.index(of: item)
        switch (indexOfTab){

        case 0:
            break;
        case 1:
            break;
        case 2:
            self.showcontroller()
            break;
        default:
            print("Default")
            break;
            //Some code here..

        }
    }
    func showcontroller() {
        let image1 = UIImage(named: "photo")
        let image2 = UIImage(named: "video")
        let actionSheet = UIAlertController(title: "", message:"", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Quick Photo", style: .default){ (action: UIAlertAction!) in
            self.imageviewcontroller.allowsEditing = false
            self.imageviewcontroller.delegate = self
            self.imageviewcontroller.sourceType = .camera
            self.present(self.imageviewcontroller, animated: true, completion: nil)
        }

        let action2 = UIAlertAction(title: "Quick Video", style: .default){ (action: UIAlertAction!) in
            self.imageviewcontroller.allowsEditing = true
            self.imageviewcontroller.delegate = self
            self.imageviewcontroller.mediaTypes = [kUTTypeMovie as String];
            self.imageviewcontroller.sourceType = .camera
            self.imageviewcontroller.cameraCaptureMode = .video
            self.present(self.imageviewcontroller, animated: true, completion: nil)
        }

        let action3 = UIAlertAction(title: "Quick Photo Post", style: .default){ (action: UIAlertAction!) in
            self.imageviewcontroller.allowsEditing = true
            self.imageviewcontroller.delegate = self
            self.imageviewcontroller.mediaTypes = [kUTTypeImage as String];
            self.present(self.imageviewcontroller, animated: true, completion: nil)
        }

        let action4 = UIAlertAction(title: "Quick Video Post", style: .default){ (action: UIAlertAction!) in
            self.imageviewcontroller.allowsEditing = true
            self.imageviewcontroller.delegate = self
            self.imageviewcontroller.mediaTypes = [kUTTypeMovie as String];
             self.imageviewcontroller.sourceType = .camera
             self.imageviewcontroller.cameraCaptureMode = .video
            self.present(self.imageviewcontroller, animated: true, completion: nil)
        }
        action1.setValue(image1?.withRenderingMode(.alwaysOriginal), forKey: "image")
        action2.setValue(image2?.withRenderingMode(.alwaysOriginal), forKey: "image")
        action3.setValue(image1?.withRenderingMode(.alwaysOriginal), forKey: "image")
        action4.setValue(image2?.withRenderingMode(.alwaysOriginal), forKey: "image")
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        actionSheet.addAction(action4)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString

        if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
            print("movie")
            let tempMedia = info[UIImagePickerControllerMediaURL] as! NSURL!
            CustomVideoAlbum.sharedInstance.saveVideo(filePath: "\(tempMedia!)")
           // CustomPhotoAlbum.sharedInstance.save(image: profileImageFromPicker)

        }
        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
            var selectedImageFromPicker: UIImage?
            let OriginalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
                selectedImageFromPicker = OriginalImage
            CustomPhotoAlbum.sharedInstance.save(image: selectedImageFromPicker!)
            self.dismiss(animated: false, completion: nil)
            self.present(self.imageviewcontroller, animated: false, completion: nil)

        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: false, completion: nil)
    }
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool{
        let index = tabBarController.viewControllers?.index(of: viewController)
        if index == 2 {
            return false
        }
        return true// you decide
    }
    // UITabBarControllerDelegate

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        print("\(buttonIndex)")
        switch (buttonIndex){

        case 0:
            print("Cancel")
        case 1:
            print("Save")
        case 2:
            print("Delete")
        default:
            print("Default")
            //Some code here..

        }
    }
    

    
}
