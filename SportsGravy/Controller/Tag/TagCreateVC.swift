//
//  TagCreateVC.swift
//  SportsGravy
//
//  Created by CSS on 16/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

protocol PassSelectorderDelegate: AnyObject {
    func selectorderArray(select:NSMutableArray!)
}

class TagCreateVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var SelectorderView: UIView!
    @IBOutlet weak var tag_txt: UITextField!
    weak var delegate:PassSelectorderDelegate?

    
    var getorderArray: NSMutableArray!
    var addOrderView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tag_txt.delegate = self
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: tag_txt.frame.height - 1, width: self.view.frame.width-40, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        tag_txt.borderStyle = UITextBorderStyle.none
        tag_txt.layer.addSublayer(bottomLine)
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
        self.delegate?.selectorderArray(select: self.getorderArray)
    }
    @IBAction func createtag(_ sender: UIButton)
    {
        
    }
    @IBAction func cancelbtn(_ sender: UIButton)
    {
      self.navigationController?.popViewController(animated: true)
    }
}
