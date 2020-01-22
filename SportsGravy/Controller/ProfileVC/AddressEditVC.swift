//
//  AddressEditVC.swift
//  SportsGravy
//
//  Created by CSS on 22/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class AddressEditVC: UIViewController {
    
    @IBOutlet weak var street1_txt: UITextField!
    @IBOutlet weak var street2_txt: UITextField!
    @IBOutlet weak var city_txt: UITextField!
    @IBOutlet weak var state_txt: UITextField!
    @IBOutlet weak var potel_txt: UITextField!
    @IBOutlet weak var country_txt: UITextField!



    override func viewDidLoad() {
        super.viewDidLoad()
  bottomlineMethod(selecttext: street1_txt)
        bottomlineMethod(selecttext: street2_txt)
        bottomlineMethod(selecttext: city_txt)
        bottomlineMethod(selecttext: state_txt)
        bottomlineMethod(selecttext: potel_txt)
        bottomlineMethod(selecttext: country_txt)
       
        
    }
    func bottomlineMethod(selecttext: UITextField)
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: selecttext.frame.height - 1, width: self.view.frame.width-40, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        selecttext.borderStyle = UITextBorderStyle.none
        selecttext.layer.addSublayer(bottomLine)
    }
    @IBAction func EditAddresscancelbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }
}
