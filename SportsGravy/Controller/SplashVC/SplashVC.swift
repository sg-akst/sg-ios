//
//  SplashVC.swift
//  SportsGravy
//
//  Created by CSS on 03/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork(){
                print("Internet Connection Available!")
            }else{
                print("Internet Connection not Available!")
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Internet Connection not Available!")

            }
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
    let objSigninvc: SigninVC = (self.storyboard?.instantiateViewController(identifier: "Signin_page"))!
    self.navigationController?.pushViewController(objSigninvc, animated: true)
        
       
    }

}
