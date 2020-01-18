//
//  TagCreateVC.swift
//  SportsGravy
//
//  Created by CSS on 16/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

protocol PassSelectorderDelegate: AnyObject {
    func selectorderArray(select:NSMutableArray!,selectindex: UIButton)
    func createAfterCallMethod()
}

class TagCreateVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var SelectorderView: UIView!
    @IBOutlet weak var tag_txt: UITextField!
    var rolebySeasonid: String!
    var getrolebyorganizationArray: NSMutableArray!
    var getTeamId: String!

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
            let btn_width = (i==0) ? 30 : 70
            
            let frame1 = (i > 3) ? (getorderArray.firstObject != nil) ? CGRect(x: 10, y: 55, width: btn_width, height: 40 ) : CGRect(x: 0 + (i * 75), y: 10, width: btn_width, height: 40 ) : (getorderArray.firstObject != nil) ? CGRect(x: 10 + (i * 75), y: 10, width: btn_width, height: 40 ) : CGRect(x: 0 + (i * 75), y: 10, width: btn_width, height: 40 )
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

        self.delegate?.selectorderArray(select: self.getorderArray,selectindex: sender)
        self.navigationController?.popViewController(animated: true)
  
    }
    @IBAction func createtag(_ sender: UIButton)
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebySeasonid!)")
        docRef.collection("Tags").document("\(tag_txt.text!)").setData(["count" : 0, "created_datetime": Date().timeIntervalSince1970,"created_uid" : "\(getuuid!)", "tag_id": "\(tag_txt.text!)", "updated_datetime" : Date().timeIntervalSince1970, "updated_uid" : ""] )
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                let organizationId: NSDictionary = self.getrolebyorganizationArray?[0] as! NSDictionary
                let docrefs = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)")
                docrefs.collection("Tags").document("\(self.tag_txt.text!)").setData(["count" : 0, "created_datetime": Date().timeIntervalSince1970,"created_uid" : "\(getuuid!)", "tag_id": "\(self.tag_txt.text!)", "updated_datetime" : Date().timeIntervalSince1970, "updated_uid" : ""] )
                { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        print(self.getorderArray.lastObject!)
                        let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                        addDoc.collection("Tags").document("\(self.tag_txt.text!)").setData(["count" : 0, "created_datetime": Date().timeIntervalSince1970,"created_uid" : "\(getuuid!)", "tag_id": "\(self.tag_txt.text!)", "updated_datetime" : Date().timeIntervalSince1970, "updated_uid" : ""] )
                        { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                                Constant.showInActivityIndicatory()
                                //Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Tag Creat Successfully")
                                self.delegate?.createAfterCallMethod()
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }

            }
            Constant.showInActivityIndicatory()
        }
    }
    @IBAction func cancelbtn(_ sender: UIButton)
    {
      self.navigationController?.popViewController(animated: true)
    }
}
