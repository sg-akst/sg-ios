//
//  OrganizationVC.swift
//  SportsGravy
//
//  Created by CSS on 22/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class OrganizationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   @IBAction func organizationcancelbtn(_ sender: UIButton)
   {
      self.navigationController?.popViewController(animated: true)
   }

}
