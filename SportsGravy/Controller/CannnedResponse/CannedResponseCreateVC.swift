//
//  CannedResponseCreateVC.swift
//  SportsGravy
//
//  Created by CSS on 16/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
protocol CreateCanresponseDelegate: AnyObject {
    func passorderArray(select:NSMutableArray!)
}

class CannedResponseCreateVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var SelectorderView: UIView!
    @IBOutlet weak var canRespons_tittle_txt: UITextField!
    @IBOutlet weak var canRespons_txv: UITextView!
    @IBOutlet weak var create_btn: UIButton!
    @IBOutlet weak var delete_btn: UIButton!
    
    
    weak var delegate:CreateCanresponseDelegate?
    var getorderArray: NSMutableArray!
    var updateArray: NSDictionary!
    var addOrderView: UIView!
    var isCreate: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        canRespons_tittle_txt.delegate = self
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: canRespons_tittle_txt.frame.height - 1, width: self.view.frame.width-40, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        canRespons_tittle_txt.borderStyle = UITextBorderStyle.none
        canRespons_tittle_txt.layer.addSublayer(bottomLine)
        if(isCreate == true)
        {
            self.delete_btn.isHidden = true
            self.create_btn.isHidden = false
            
        }
        else
        {
           self.delete_btn.isHidden = false
            self.create_btn.isHidden = true
            //let dic: NSDictionary = updateArray?[0] as! NSDictionary
            self.canRespons_tittle_txt.text = updateArray.value(forKey: "cannedResponseTitle") as? String
            self.canRespons_txv.text = updateArray.value(forKey: "cannedResponseDesc") as? String
            
        }
        canRespons_txv.layer.borderColor = UIColor.darkGray.cgColor
        canRespons_txv.layer.borderWidth = 0.5
        canRespons_txv.layer.masksToBounds = true
        getuserDetail()
    }
    func getuserDetail()
    {
        self.addOrderView = UIView()
        self.addOrderView.frame = self.SelectorderView.bounds
        for i in 0..<self.getorderArray.count
        {
            
            let frame1 = (i > 3) ? (getorderArray.firstObject != nil) ? CGRect(x: 10, y: 55, width: 70, height: 40 ) : CGRect(x: 0 + (i * 75), y: 10, width: 70, height: 40 ) : (getorderArray.firstObject != nil) ? CGRect(x: 10 + (i * 75), y: 10, width: 70, height: 40 ) : CGRect(x: 0 + (i * 75), y: 10, width: 70, height: 40 )
            let button = UIButton(frame: frame1)
            button.setTitle("\(getorderArray[i] as! String)", for: .normal)
            let lastIndex: Int = getorderArray.count-1
            
            if(lastIndex == i)
           {
            button.setTitleColor(UIColor.gray, for: .normal)

            }
            else
           {
            button.setTitleColor(UIColor.blue, for: .normal)

            }
            
            button.titleLabel?.textAlignment = .center
            button.sizeToFit()
            button.tag = i
            self.addOrderView.addSubview(button)
            button.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)

        }
       
        self.SelectorderView.addSubview(addOrderView)
    }
    @objc func orderselectmethod(_ sender: UIButton)
    {
        let getTag = sender.tag
        for i in 0..<self.getorderArray.count
        {
            if(i <= getTag)
            {
                print("before\(i)")
            }
            else
            {
                print("after\(i)")
                self.getorderArray.removeObject(at: i)

            }
        }
        self.delegate?.passorderArray(select: self.getorderArray)
    }
    @IBAction func createtag(_ sender: UIButton)
    {
        
    }
    @IBAction func cancelbtn(_ sender: UIButton)
    {
      self.navigationController?.popViewController(animated: true)
    }
    
}
