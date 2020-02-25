//
//  CommonTabBarVC.swift
//  SportsGravy
//
//  Created by CSS on 25/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class CommonTabBarVC: UITabBarController, sidemenuDelegate, UITabBarControllerDelegate {
    func sidemenuselectRole(role: String, roleArray: NSMutableArray) {
        print("delegate")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let obj: SidemenuVC = (self.storyboard?.instantiateViewController(identifier: "side"))!
//        obj.delegate = self

        
    }
    

    
}
