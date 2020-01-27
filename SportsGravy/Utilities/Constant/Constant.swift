//
//  Constant.swift
//  SportsGravy
//
//  Created by CSS on 02/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

 let BaseUrl = "https://us-central1-sports-gravy-app.cloudfunctions.net/"


class Constant: NSObject {
    static let sharedinstance = Constant()

    var getPlayerbyuid:String = BaseUrl + "getPlayersByUid?"
    var getGuardiansbyuid:String = BaseUrl + "getGuardiansByUid?"
    var getOrganizationbyuid: String = BaseUrl + "getOrganizationByUid?"

    static func internetconnection(vc: UIViewController)
    {
        if Reachability.isConnectedToNetwork()
        {
            print("Internet Connection Available!")
                   
        }else{
          print("Internet Connection not Available!")
          Constant.showAlertMessage(vc: vc, titleStr: "SportsGravy", messageStr: "Internet Connection not Available!")
          }
               
    }

    
    struct ScreenSize
      {
          static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
          static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
          static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
          static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
      }
    
      static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
      
      static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
      
      static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
      
      static let IS_IPHONE_7P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
      
      static let IS_IPHONE_8P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
      
      static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
      
      static let IS_IPHONE_XS = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0

    // Color convert
    static func getUIColor(hex: String, alpha: Double = 1.0) -> UIColor? {
         var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
         
         if (cleanString.hasPrefix("#")) {
             cleanString.remove(at: cleanString.startIndex)
         }
         
         if ((cleanString.count) != 6) {
             return nil
         }
         
         var rgbValue: UInt32 = 0
         Scanner(string: cleanString).scanHexInt32(&rgbValue)
         
         return UIColor(
             red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
             green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
             blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
             alpha: CGFloat(1.0)
         )
     }
    static func uicolorFromHex(_ rgbValue:UInt32, alpha : CGFloat)->UIColor

       {
           let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
           let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
           let blue = CGFloat(rgbValue & 0xFF) / 255.0
           return UIColor(red:red, green:green, blue:blue, alpha: alpha)
       }
    // Actitivity
   static var loadingviewcontain: UIView!
   static var actInd: UIActivityIndicatorView!
    
static func showActivityIndicatory(uiView: UIView) {
    self.loadingviewcontain = UIView()
    self.loadingviewcontain.frame = uiView.frame
    self.loadingviewcontain.center = uiView.center
    self.loadingviewcontain.backgroundColor = uicolorFromHex(0xffffff, alpha: 0.3) //UIColorFromHex(0xffffff, alpha: 0.3)

    let loadingView: UIView = UIView()
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
    loadingView.backgroundColor = uicolorFromHex(0x444444, alpha: 0.7) //UIColorFromHex(0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10

    self.actInd = UIActivityIndicatorView()
    self.actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
    self.actInd.activityIndicatorViewStyle =
            UIActivityIndicatorView.Style.large
    self.actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                            y: loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        self.loadingviewcontain.addSubview(loadingView)
        uiView.addSubview(self.loadingviewcontain)
    self.actInd.startAnimating()
    }
    
static func showInActivityIndicatory() {

    actInd.stopAnimating()
    self.loadingviewcontain.removeFromSuperview()
    }
    
    static func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                   //Cancel Action
               }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    // email validsation
  static func isValidEmail(testStr:String) -> Bool {
       print("validate emilId: \(testStr)")
       let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
       return result
   }
}

