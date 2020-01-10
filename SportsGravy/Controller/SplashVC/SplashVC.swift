//
//  SplashVC.swift
//  SportsGravy
//
//  Created by CSS on 03/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import SWRevealViewController

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UserDefaults.standard.object(forKey: "UUID") != nil{
            let swrvc: SWRevealViewController = (self.storyboard?.instantiateViewController(identifier: "revealvc"))!
            self.navigationController?.pushViewController(swrvc, animated: true)

        } else {
          let objSigninvc: SigninVC = (self.storyboard?.instantiateViewController(identifier: "Signin_page"))!
             self.navigationController?.pushViewController(objSigninvc, animated: true)
                 
        }

    }
    
}
