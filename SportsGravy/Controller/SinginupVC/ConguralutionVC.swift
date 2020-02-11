//
//  ConguralutionVC.swift
//  SportsGravy
//
//  Created by CSS on 11/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class ConguralutionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func setstart(_ sender: UIButton)
    {
        let objSigninvc: SigninVC = (self.storyboard?.instantiateViewController(identifier: "Signin_page"))!
        self.navigationController?.pushViewController(objSigninvc, animated: true)
    }
    
}
