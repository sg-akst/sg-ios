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
            self.create_btn.setTitle("Update", for: .normal)
            self.canRespons_tittle_txt.text = updateArray.value(forKey: "cannedResponseTitle") as? String
            self.canRespons_txv.text = updateArray.value(forKey: "cannedResponseDesc") as? String
            let count : Int = updateArray.value(forKey: "count") as! Int
            delete_btn.backgroundColor = (count > 0 ) ? UIColor.gray : UIColor.red
            
        }
        canRespons_txv.layer.borderColor = UIColor.darkGray.cgColor
        canRespons_txv.layer.borderWidth = 0.5
        canRespons_txv.layer.masksToBounds = true
        getuserDetail()
    }
    func getuserDetail()
    {
        let buttons: NSMutableArray = NSMutableArray()
        var indexOfLeftmostButtonOnCurrentLine: Int = 0
        var runningWidth: CGFloat = 10.0
        let maxWidth: CGFloat = 375.0
        let horizontalSpaceBetweenButtons: CGFloat = 5.0
        let verticalSpaceBetweenButtons: CGFloat = 5.0
        self.addOrderView = UIView()
        self.addOrderView.frame = self.SelectorderView.bounds
        for i in 0..<self.getorderArray.count
        {
          selectOption_btn = UIButton(type: .roundedRect)
            selectOption_btn.titleLabel?.font = UIFont(name: "Arial", size: 20)
            selectOption_btn.setTitle("\(getorderArray[i] as! String)", for: .normal)
            let title: String = getorderArray?[i] as! String
            selectOption_btn.translatesAutoresizingMaskIntoConstraints = false
            let attrStr = NSMutableAttributedString(string: "\(title)")
            if(i != 0)
            {
                attrStr.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 1))
            }
            selectOption_btn.setAttributedTitle(attrStr, for: .normal)
            let lastIndex: Int = getorderArray.count-1
                       
            if(lastIndex == i)
         {
             selectOption_btn.tintColor = UIColor.gray
             selectOption_btn.setTitleColor(UIColor.gray, for: .normal)
             selectOption_btn.isUserInteractionEnabled = false
             }
             else
             {
         selectOption_btn.tintColor = UIColor.blue
         selectOption_btn.setTitleColor(UIColor.blue, for: .normal)
         selectOption_btn.isUserInteractionEnabled = true

         }
            
            selectOption_btn.titleLabel?.textAlignment = .center
            selectOption_btn.sizeToFit()
            selectOption_btn.tag = i
            self.addOrderView.addSubview(selectOption_btn)
            selectOption_btn.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)
             if ((i == 0) || (runningWidth + selectOption_btn.frame.size.width > maxWidth)){
                 runningWidth = selectOption_btn.frame.size.width
                if(i==0)
                {
                    // first button (top left)
                    // horizontal position: same as previous leftmost button (on line above)
                   let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: selectOption_btn, attribute: .left, relatedBy: .equal, toItem: self.addOrderView, attribute: .left, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                   selectOption_btn.setAttributedTitle(attrStr, for: .normal)
                    addOrderView.addConstraint(horizontalConstraint)
                    
                    // vertical position:
                    let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: selectOption_btn, attribute: .top, relatedBy: .equal, toItem: self.addOrderView, attribute: .top, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                    self.addOrderView.addConstraint(verticalConstraint)
                        
                        //[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop              multiplier:1.0f constant:verticalSpaceBetweenButtons];
                                //   [self.view addConstraint:verticalConstraint];

                }
                else{
                    // put it in new line
                    let previousLeftmostButton: UIButton = buttons.object(at: indexOfLeftmostButtonOnCurrentLine) as! UIButton

                    // horizontal position: same as previous leftmost button (on line above)
                    let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: selectOption_btn, attribute: .left, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .left, multiplier: 1.0, constant: 0.0)
                    self.addOrderView.addConstraint(horizontalConstraint)

                        //[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
                   // [self.view addConstraint:horizontalConstraint];

                    // vertical position:
                    let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: selectOption_btn, attribute: .top, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .bottom, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                    self.addOrderView.addConstraint(verticalConstraint)

                    //[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:verticalSpaceBetweenButtons];
                    //[self.view addConstraint:verticalConstraint];

                    indexOfLeftmostButtonOnCurrentLine = i
                }
            }
            else
            {
                runningWidth += selectOption_btn.frame.size.width + horizontalSpaceBetweenButtons;

                let previousButton: UIButton = buttons.object(at: i-1) as! UIButton
                           
                let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: selectOption_btn, attribute: .left, relatedBy: .equal, toItem: previousButton, attribute: .right, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                self.addOrderView.addConstraint(horizontalConstraint)
                let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: selectOption_btn, attribute: .top, relatedBy: .equal, toItem: previousButton, attribute: .top, multiplier: 1.0, constant: 0.0)
                self.addOrderView.addConstraint(verticalConstraint)
            }
            buttons.add(selectOption_btn)

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
            if(canRespons_tittle_txt.text == nil || canRespons_tittle_txt.text?.isEmpty == true)
            {
                Constant.showAlertMessage(vc: self, titleStr: "SportGravy", messageStr: "Please enter Canned Response Tiltle")
            }
            else
            {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebySeasonid!)")
        docRef.collection("CannedResponse").document("\(canRespons_tittle_txt.text!)").setData(["count" : 0, "created_datetime": Date(),"created_uid" : "\(getuuid!)", "cannedResponseTitle": "\(canRespons_tittle_txt.text!)","cannedResponseDesc":"\(canRespons_txv.text!)", "updated_datetime" : Date(), "updated_uid" : ""] )
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                let organizationId: NSDictionary = self.getrolebyorganizationArray?[0] as! NSDictionary
                let docrefs = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)")
                docrefs.collection("CannedResponse").document("\(self.canRespons_tittle_txt.text!)").setData(["count" : 0, "created_datetime": Date(),"created_uid" : "\(getuuid!)", "cannedResponseTitle": "\(self.canRespons_tittle_txt.text!)","cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date(), "updated_uid" : ""] )
                { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        print(self.getorderArray.lastObject!)
                        let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                        addDoc.collection("CannedResponse").document("\(self.canRespons_tittle_txt.text!)").setData(["count" : 0, "created_datetime": Date(),"created_uid" : "\(getuuid!)", "cannedResponseTitle": "\(self.canRespons_tittle_txt.text!)","cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date(), "updated_uid" : ""] )
                        { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                                Constant.showInActivityIndicatory()
                                self.alertermsg(msg: "CannedResponse successfully Created")
//                                self.delegate?.createAfterCallMethod()
//                                self.navigationController?.popViewController(animated: false)

                            }
                        }
                    }
                }
                
            }
            Constant.showInActivityIndicatory()
        }
            }
        }
        else
        {
                 Constant.internetconnection(vc: self)
                 Constant.showActivityIndicatory(uiView: self.view)
                 let getuuid = UserDefaults.standard.string(forKey: "UUID")
                 let db = Firestore.firestore()
            let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebySeasonid!)")            
            docRef.collection("CannedResponse").document("\(updateArray.value(forKey: "cannedResponseTitle") as! String)").updateData(["cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date()])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    Constant.showInActivityIndicatory()

                } else {
                    print("Document successfully updated")
                    let organizationId: NSDictionary = self.getrolebyorganizationArray?[0] as! NSDictionary
                    let docrefs = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)")
                    
                    docrefs.collection("CannedResponse").document("\(self.updateArray.value(forKey: "cannedResponseTitle") as! String)").updateData(["cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date()])
                    { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                            Constant.showInActivityIndicatory()

                        } else {
                            print("Document successfully updated")
                            let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                            addDoc.collection("CannedResponse").document("\(self.updateArray.value(forKey: "cannedResponseTitle") as! String)").updateData(["cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date()])
                            { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                    Constant.showInActivityIndicatory()

                                } else {
                                    print("Document successfully updated")
                                    Constant.showInActivityIndicatory()
                                    self.alertermsg(msg: "CannedResponse successfully updated")
//                                    self.delegate?.createAfterCallMethod()
//                                    self.navigationController?.popViewController(animated: false)

                                    
                                }
                            }

                        }

                    }
                }
            }
                 
        }
               
    }
    
    func alertermsg(msg: String)
        {
            let alert = UIAlertController(title: "SportsGravy", message: msg, preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
    //        self.delegate?.usernameupdateSuccess()
            self.navigationController?.popViewController(animated: true)
                self.delegate?.createAfterCallMethod()
                
                   }))
            
            self.present(alert, animated: true, completion: nil)
            
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
