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
        if #available(iOS 13.0, *) {
            let objSigninvc: SigninVC = (self.storyboard?.instantiateViewController(identifier: "Signin_page"))!
            self.navigationController?.pushViewController(objSigninvc, animated: true)

        } else {
            let objSigninvc: SigninVC = (self.storyboard?.instantiateViewController(withIdentifier: "Signin_page"))! as! SigninVC
                       self.navigationController?.pushViewController(objSigninvc, animated: true)
        }
    }
    
}
