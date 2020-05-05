//
//  AppDelegate.swift
//  SportsGravy
//
//  Created by CSS on 02/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseFirestore

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
    var onlineStatusTimer : Timer!
    var reachability: Reachability = Reachability.networkReachabilityForInternetConnection()!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        
       
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        DispatchQueue.main.async {
                          self.startTimer()
                      }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        DispatchQueue.main.async {
            //self.everyhalfnoonTimer()
          // reachability = Reachability.networkReachabilityForInternetConnection()!

            let netStatus = self.reachability.currentReachabilityStatus
                   switch netStatus {
                   case .notReachable:
                   break
                   case .reachableViaWiFi:
                    self.wificonnectionlocaldatabaseupload()
                   //print(netStatus)
                   break
                   case .reachableViaWWAN:
                   break
                   }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
   func wificonnectionlocaldatabaseupload()
      {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if #available(iOS 13.0, *) {
            let objpostvc: PostImageVC = storyBoard.instantiateViewController(identifier: "postimage")
            objpostvc.localDatauploadfirebase()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocalDatabase"), object: nil)
        } else {
            let objpostvc = storyBoard.instantiateViewController(withIdentifier: "postimage") as? PostImageVC

           // let objpostvc = storyBoard.instantiateViewController(identifier: "postimage") as? PostImageVC
            objpostvc!.localDatauploadfirebase()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LocalDatabase"), object: nil)
        }
      }
    func application(_ app: UIApplication, open openurl: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(openurl)
        let url = "\(openurl)"
        let queryItems = URLComponents(string: url)?.queryItems
        let param1 = queryItems?.filter({$0.name == "uid"}).first
        print(param1?.value as Any)
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "Signup_page") as! SignupVC
        viewController.uidString = param1?.value
        let navigationController = UINavigationController.init(rootViewController: viewController)
              
        self.window?.rootViewController = navigationController
        navigationController.navigationBar.isHidden = true

              self.window?.makeKeyAndVisible()
        
        
        return true
    }
    func startTimer(){
        
        let refreshToken: String = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        if(refreshToken != "")
        {
            onlineStatusTimer = Timer.scheduledTimer(timeInterval:0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
            
        }
    }
//    func everyhalfnoonTimer(){
//          
//            Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
//                                 if error != nil {
//                                                 
//                                                 return;
//                                               }
//                                                 print("Token=>\(idToken!)")
//                UserDefaults.standard.removeObject(forKey: "idtoken")
//                UserDefaults.standard.set(idToken, forKey: "idtoken")
//                                             }
//          }
    @objc func timerAction() {
//        let refreshToken: String = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
//        if(refreshToken != "")
//        {
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                               if error != nil {
                                               // Handle error
                                               return;
                                             }
                                               print("Token=>\(idToken!)")
                UserDefaults.standard.removeObject(forKey: "idtoken")
                UserDefaults.standard.set(idToken, forKey: "idtoken")
        }
                           
    }
   // }

    func application(_ application: UIApplication,
                            performFetchWithCompletionHandler completionHandler:
               @escaping (UIBackgroundFetchResult) -> Void) {
               print("1 hour")
               DispatchQueue.main.async {
                   self.startTimer()
               }
               // Check for new data.
       //        if let newData = fetchUpdates() {
       ////            addDataToFeed(newData: newData)
       //            completionHandler(.newData)
       //        }
               completionHandler(.noData)
           }
}

