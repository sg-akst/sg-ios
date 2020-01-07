//
//  Dashboardvc.swift
//  SportsGravy
//
//  Created by CSS on 07/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import SWRevealViewController
class Dashboardvc: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

                if revealViewController() != nil {
        //            revealViewController().rearViewRevealWidth = 62
                    //menuButton.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
                   

                   // revealViewController().rightViewRevealWidth = 150
//                    extraButton.target = revealViewController()
//                    extraButton.action = "rightRevealToggle:"

                    view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                    
                
                }

    }
    @IBAction func menuBtn(_ sender: UIButton)
    {
        self.revealViewController().revealToggle(self)

    }
    
}
