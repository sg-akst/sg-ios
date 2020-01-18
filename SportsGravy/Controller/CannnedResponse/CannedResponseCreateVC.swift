//
//  CannedResponseCreateVC.swift
//  SportsGravy
//
//  Created by CSS on 16/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


protocol CreateCanresponseDelegate: AnyObject {
    func passorderArray(select:NSMutableArray!, selectindex: UIButton)
    func createAfterCallMethod()

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
    
    var rolebySeasonid: String!
    var getrolebyorganizationArray: NSMutableArray!
    var selectOption_btn: UIButton!
    var getTeamId: String!
    
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
            self.canRespons_tittle_txt.isUserInteractionEnabled = true

            
        }
        else
        {
           self.delete_btn.isHidden = false
            self.create_btn.isHidden = false
            self.canRespons_tittle_txt.isUserInteractionEnabled = false
            self.create_btn.setTitle("UPDATE", for: .normal)
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
            selectOption_btn = UIButton(frame: frame1)
            selectOption_btn.setTitle("\(getorderArray[i] as! String)", for: .normal)
            let lastIndex: Int = getorderArray.count-1
            
            if(lastIndex == i)
           {
            selectOption_btn.setTitleColor(UIColor.gray, for: .normal)

            }
            else
           {
            selectOption_btn.setTitleColor(UIColor.blue, for: .normal)

            }
            
            selectOption_btn.titleLabel?.textAlignment = .center
            selectOption_btn.sizeToFit()
            selectOption_btn.tag = i
            self.addOrderView.addSubview(selectOption_btn)
            selectOption_btn.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)

        }
       
        self.SelectorderView.addSubview(addOrderView)
    }
    @objc func orderselectmethod(_ sender: UIButton)
    {
        self.delegate?.passorderArray(select: self.getorderArray,selectindex: sender)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func createtag(_ sender: UIButton)
    {
        if(isCreate == true)
        {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebySeasonid!)")
        docRef.collection("CannedResponse").document("\(canRespons_tittle_txt.text!)").setData(["count" : 0, "created_datetime": Date().timeIntervalSince1970,"created_uid" : "\(getuuid!)", "cannedResponseTitle": "\(canRespons_tittle_txt.text!)","cannedResponseDesc":"\(canRespons_txv.text!)", "updated_datetime" : Date().timeIntervalSince1970, "updated_uid" : ""] )
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                let organizationId: NSDictionary = self.getrolebyorganizationArray?[0] as! NSDictionary
                let docrefs = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)")
                docrefs.collection("CannedResponse").document("\(self.canRespons_tittle_txt.text!)").setData(["count" : 0, "created_datetime": Date().timeIntervalSince1970,"created_uid" : "\(getuuid!)", "cannedResponseTitle": "\(self.canRespons_tittle_txt.text!)","cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date().timeIntervalSince1970, "updated_uid" : ""] )
                { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        print(self.getorderArray.lastObject!)
                        let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                        addDoc.collection("CannedResponse").document("\(self.canRespons_tittle_txt.text!)").setData(["count" : 0, "created_datetime": Date().timeIntervalSince1970,"created_uid" : "\(getuuid!)", "cannedResponseTitle": "\(self.canRespons_tittle_txt.text!)","cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date().timeIntervalSince1970, "updated_uid" : ""] )
                        { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                                Constant.showInActivityIndicatory()
                                //Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "CannedResponse Creat Successfully")
                                //self.selectOption_btn.sendActions(for: .touchUpInside)
                                self.delegate?.createAfterCallMethod()
                                self.navigationController?.popViewController(animated: false)

                            }
                        }
                    }
                }
                
            }
            Constant.showInActivityIndicatory()
        }
        }
        else
        {
                 Constant.internetconnection(vc: self)
                 Constant.showActivityIndicatory(uiView: self.view)
                 let getuuid = UserDefaults.standard.string(forKey: "UUID")
                 let db = Firestore.firestore()
            let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebySeasonid!)")            
            docRef.collection("CannedResponse").document("\(updateArray.value(forKey: "cannedResponseTitle") as! String)").updateData(["cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date().timeIntervalSince1970])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    Constant.showInActivityIndicatory()

                } else {
                    print("Document successfully updated")
                    let organizationId: NSDictionary = self.getrolebyorganizationArray?[0] as! NSDictionary
                    let docrefs = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)")
                    
                    docrefs.collection("CannedResponse").document("\(self.updateArray.value(forKey: "cannedResponseTitle") as! String)").updateData(["cannedResponseTitle": "\(self.canRespons_tittle_txt.text!)","cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date().timeIntervalSince1970])
                    { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                            Constant.showInActivityIndicatory()

                        } else {
                            print("Document successfully updated")
                            let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                            addDoc.collection("CannedResponse").document("\(self.updateArray.value(forKey: "cannedResponseTitle") as! String)").updateData(["cannedResponseTitle": "\(self.canRespons_tittle_txt.text!)","cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date().timeIntervalSince1970])
                            { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                    Constant.showInActivityIndicatory()

                                } else {
                                    print("Document successfully updated")
                                    Constant.showInActivityIndicatory()
                                    self.delegate?.createAfterCallMethod()
                                    self.navigationController?.popViewController(animated: false)

                                    
                                }
                            }

                        }

                    }
                }
            }
                 
        }
               
    }
    func deleteMethod()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebySeasonid!)")
        docRef.collection("CannedResponse").document("\(updateArray.value(forKey: "cannedResponseTitle")!)").delete()
        { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                let organizationId: NSDictionary = self.getrolebyorganizationArray?[0] as! NSDictionary
                let docrefs = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document()
                docrefs.collection("CannedResponse").document("\(self.updateArray.value(forKey: "cannedResponseTitle")!)").delete()
                { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                         let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document().collection("seasons").document().collection("teams").document("\(self.getorderArray.lastObject!)")
                        addDoc.collection("CannedResponse").document("\(self.updateArray.value(forKey: "cannedResponseTitle")!)").delete()
                        { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                                Constant.showInActivityIndicatory()
                                self.delegate?.createAfterCallMethod()
                                self.navigationController?.popViewController(animated: false)
                            }
                        }

                    }

                }
                Constant.showInActivityIndicatory()

                
            }
        }
    }
    @IBAction func deleteGroup_Method(_ sender: UIButton)
       {
//           let indexno = sender.tag
//           let teamDic: NSDictionary = self.updateArray?[indexno] as! NSDictionary
           let count : Int = updateArray.value(forKey: "count") as! Int
           let isDelete: Bool = (count > 0 ) ? false : true
           if(isDelete == false)
           {
               Constant.showAlertMessage(vc: self, titleStr: "Unable To Delete", messageStr: "System user group can't able to delete")
           }
           else
           {
               let alert = UIAlertController(title: " Delete User Group ", message: "Are you sure want to delete custom group?", preferredStyle: UIAlertController.Style.alert);
               alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { _ in
                          //Cancel Action
                      }))
               alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { _ in
                   self.deleteMethod()
                }))
               
               self.present(alert, animated: true, completion: nil)
               
               
           }

       }
    @IBAction func cancelbtn(_ sender: UIButton)
    {
      self.navigationController?.popViewController(animated: true)
    }
    
}
