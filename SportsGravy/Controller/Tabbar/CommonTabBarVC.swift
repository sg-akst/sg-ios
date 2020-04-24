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
import Alamofire
import ImagePicker

class CommonTabBarVC: UITabBarController, sidemenuDelegate, UITabBarControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//         self.getPostimageUrl = NSMutableArray()
//               self.Select_post_image = images
//               isImage = true
        if images.count > 0
        {
                   selectedImageFromPicker = images
        }
               
        imagePicker.dismiss(animated: true, completion: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuickimageandvideoViewController") as! QuickimageandvideoViewController
        vc.backgroundImage = selectedImageFromPicker
        vc.finalDataDictionary=tempUserinfoDic
        vc.isImage = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)

    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)

    }
    
    
    let imageviewcontroller = UIImagePickerController()
    let tempUserinfoDic = NSMutableDictionary()
    
    
    func sidemenuselectRole(role: String, roleArray: NSMutableArray) {
        print("delegate")
    }
    
    var clickPhotoTitle : String!
    var clickVideoTitle : String!
var selectedImageFromPicker: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.delegate = self
                if revealViewController() != nil {                            revealViewController().rearViewRevealWidth = self.view.frame.size.width - 70
                           view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                    }
        self.getuserByid()
    }
    
    func getuserByid() {
            Constant.internetconnection(vc: self)
            //Constant.showActivityIndicatory(uiView: self.view)
        let getuserByUid: String = Constant.sharedinstance.getUserByUId  //"https://us-central1-sportsgravy-testing.cloudfunctions.net/getuserByUid?"
        let token = UserDefaults.standard.string(forKey: "idtoken")
       // print(token)
        let header: HTTPHeaders = [
            "idtoken": UserDefaults.standard.string(forKey: "idtoken") ?? ""]
                        var param:[String:AnyObject] = [:]
                       param["uid"] = UserDefaults.standard.string(forKey: "UUID") as AnyObject?

                       AF.request(getuserByUid, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON{ (response:AFDataResponse<Any>) in
                        Constant.showInActivityIndicatory()

                           if(!(response.error != nil)){
                               switch (response.result)
                               {
                               case .success(let json):
                                 let jsonData = json
                                let info = jsonData as? NSDictionary
                                    let insideData = info?["data"] as? NSDictionary
                                    if let userInfo = info?["data"] as? NSDictionary {
                                        for item in userInfo {
                                            if "\(item.0)" != "roles_by_seasons" {
                                                self.tempUserinfoDic[item.0] = "\(item.1)"
                                            }
                                        }
                                    }
                                 if(self.tempUserinfoDic.count>0)
                                 {
                                    print("tempUserinfoDic",self.tempUserinfoDic)
                                    let roles_by_seasons = insideData?["roles_by_seasons"] as? NSArray
                                    let roles_by_seasons_Array: NSMutableArray = []
                                       
                                    for item in (roles_by_seasons as? [[String:Any]])! {
                                        var roles_by_seasons_Dict = [String: Any]()
                                        var isItemRemoved = false
                                        if item["organization_id"]! as? String != "" {
                                            roles_by_seasons_Dict["organization_id"] = item["organization_id"]! as? String
                                        } else {
                                            isItemRemoved = true
                                        }
                                        if item["organization_name"]! as? String != "" {
                                             roles_by_seasons_Dict["organization_name"] = item["organization_name"]! as? String
                                        } else {
                                            isItemRemoved = true
                                        }
                                        if item["organization_abbrev"]! as? String != "" {
                                             roles_by_seasons_Dict["organization_abbrev"] = item["organization_abbrev"]! as? String
                                        } else {
                                            isItemRemoved = true
                                        }
                                        if (item["sport_id"] != nil) {
                                            roles_by_seasons_Dict["sport_id"] = item["sport_id"]! as? String
                                        } else {
                                            isItemRemoved = true
                                        }
                                        if let item = item["sport_name"] as? String {
                                            if item != "" {
                                                roles_by_seasons_Dict["sport_name"] = item
                                            } else {
                                                isItemRemoved = true
                                            }
                                        }
    //                                    if item["sport_name"]! as? String != "" {
    //                                        roles_by_seasons_Dict["sport_name"] = item["sport_name"]! as? String
    //                                    }
                                        if item["role_by_season_id"]! as? String != "" {
                                            roles_by_seasons_Dict["roleBySeason_id"] = item["role_by_season_id"]! as? String
                                        } else {
                                            isItemRemoved = true
                                        }
                                        if (item["season_id"] != nil){
                                            roles_by_seasons_Dict["season_id"] = item["season_id"]! as? String
                                        } else {
                                            isItemRemoved = true
                                        }
                                        if let item = item["season_label"] as? String {
                                            if item != "" {
                                                roles_by_seasons_Dict["season_name"] = item
                                            } else {
                                                isItemRemoved = true
                                            }
                                        }
                                        if (item["level_id"] != nil) {
                                            roles_by_seasons_Dict["level_id"] = item["level_id"]! as? String
                                        } else {
                                            isItemRemoved = true
                                        }
                                        if let item = item["level_name"] as? String {
                                            if item != "" {
                                                roles_by_seasons_Dict["level_name"] = item
                                            } else {
                                                isItemRemoved = true
                                            }
                                        }
    //                                    if item["level_name"]! as? String != "" {
    //                                        roles_by_seasons_Dict["level_name"] = item["level_name"]! as? String
    //                                    }
                                        if (item["team_id"] != nil) {
                                            roles_by_seasons_Dict["team_id"] = item["team_id"]! as? String
                                        } else {
                                            isItemRemoved = true
                                        }
                                        if let item = item["team_name"] as? String {
                                            if item != "" {
                                                roles_by_seasons_Dict["team_name"] = item
                                            } else {
                                                isItemRemoved = true
                                            }
                                        }
                                        let currentrole = UserDefaults.standard.string(forKey: "RoleType")
                                        if !roles_by_seasons_Array.contains(roles_by_seasons_Dict) && !isItemRemoved && "\(item["role"] ?? "coach")" == "coach"{
                                            roles_by_seasons_Array.add(roles_by_seasons_Dict)
                                        }
                                
                                    }
                                    print("arrayvalue",roles_by_seasons_Array)
                                    let userdefaults = UserDefaults.standard
                                    userdefaults.set(roles_by_seasons_Array, forKey: "roles_by_seasons_Array")
                                    //Constant.showInActivityIndicatory()
                                 }
                                   break

                               case .failure(_):
                                   //Constant.showInActivityIndicatory()

                                   break
                               }
                           }
                           else
                           {
                               //Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: "\(Constant.sharedinstance.errormsgDetail)")
                               Constant.showInActivityIndicatory()

                           }
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
        let action1 = UIAlertAction(title:"Quick Photo", style: .default){ (action: UIAlertAction!) in
            self.imageviewcontroller.allowsEditing = false
            self.imageviewcontroller.delegate = self
            self.imageviewcontroller.sourceType = .camera
            self.imageviewcontroller.mediaTypes = [(kUTTypeImage as String)]
            self.imageviewcontroller.cameraCaptureMode = .photo
            self.clickPhotoTitle = "1"
            self.present(self.imageviewcontroller, animated: true, completion: nil)
        }

        let action2 = UIAlertAction(title:"Quick Video", style: .default){ (action: UIAlertAction!) in
            self.imageviewcontroller.allowsEditing = true
            self.imageviewcontroller.delegate = self
            self.imageviewcontroller.mediaTypes = [kUTTypeMovie as String];
            self.imageviewcontroller.sourceType = .camera
            self.imageviewcontroller.cameraCaptureMode = .video
            self.clickVideoTitle = "2"
            self.present(self.imageviewcontroller, animated: true, completion: nil)
        }

        let action3 = UIAlertAction(title: "Quick Photo Post", style: .default){ (action: UIAlertAction!) in
//            self.imageviewcontroller.allowsEditing = true
//            self.imageviewcontroller.delegate = self
//            self.imageviewcontroller.sourceType = .camera
//            self.imageviewcontroller.mediaTypes = [kUTTypeImage as String]
            self.clickPhotoTitle = "3"
//
//            self.present(self.imageviewcontroller, animated: true, completion: nil)
            
            let config = Configuration()
            config.doneButtonTitle = "Cancel"
            config.noImagesTitle = "Sorry! There are no images here!"
            config.recordLocation = false
            config.allowVideoSelection = true

            let imagePicker = ImagePickerController(configuration: config)
            imagePicker.delegate = self

            self.present(imagePicker, animated: true, completion: nil)
        }

        let action4 = UIAlertAction(title: "Quick Video Post", style: .default){ (action: UIAlertAction!) in
            self.imageviewcontroller.allowsEditing = true
            self.imageviewcontroller.delegate = self
            self.imageviewcontroller.mediaTypes = [kUTTypeMovie as String];
             self.imageviewcontroller.sourceType = .camera
             self.imageviewcontroller.cameraCaptureMode = .video
            self.clickVideoTitle = "4"
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
            let tempMedia = info[UIImagePickerControllerMediaURL] as! NSURL

            if(self.clickVideoTitle == "2")
            {
//              let tempMedia = info[UIImagePickerControllerMediaURL] as! NSURL!
                CustomVideoAlbum.sharedInstance.saveVideo(filePath: "\(tempMedia)")
                self.present(self.imageviewcontroller, animated: false, completion: nil)

            }
            else
            {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuickimageandvideoViewController") as! QuickimageandvideoViewController
            vc.tempMedia = tempMedia as URL?
            vc.finalDataDictionary=tempUserinfoDic
            vc.isImage = false
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
            var takePhoto: UIImage = UIImage()
                       if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                       takePhoto = editedImage
                       }
            if let OriginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                           takePhoto = OriginalImage
                       }
            if(self.clickPhotoTitle == "1")
            {
            CustomPhotoAlbum.sharedInstance.save(image: takePhoto)
            self.present(self.imageviewcontroller, animated: false, completion: nil)

            }
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
