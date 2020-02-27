//
//  RateVC.swift
//  SportsGravy
//
//  Created by CSS on 08/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class RateVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

         if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = self.view.frame.size.width - 70
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
    }
    
    @IBAction func RatemenuBtn(_ sender: UIButton)
       {
           self.revealViewController().revealToggle(self)

       }

}
