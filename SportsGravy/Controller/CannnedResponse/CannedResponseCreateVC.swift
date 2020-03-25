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

class CannedResponseCreateVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var SelectorderView: UIView!
    @IBOutlet weak var canRespons_tittle_txt: UITextField!
    @IBOutlet weak var canRespons_txv: UITextView!
    @IBOutlet weak var create_btn: UIButton!
    @IBOutlet weak var navigation_title_lbl: UILabel!
    
    
    
    weak var delegate:CreateCanresponseDelegate?
    var getorderArray: NSMutableArray!
    var updateArray: NSDictionary!
    var addOrderView: UIView!
    var isCreate: Bool!
    
    var rolebySeasonid: String!
    var getrolebyorganizationArray: NSMutableArray!
    var selectOption_btn: UIButton!
    var getTeamId: String!
    
    var getorg_id: String!
    var getSport_id: String!
    var season_id: String!
    
    @IBOutlet weak var orderviewheight: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        canRespons_tittle_txt.delegate = self
        canRespons_txv.delegate = self
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -20, y: canRespons_tittle_txt.frame.height - 1, width: self.view.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        canRespons_tittle_txt.borderStyle = UITextBorderStyle.none
        canRespons_tittle_txt.layer.addSublayer(bottomLine)
        if(isCreate == true)
        {
            self.create_btn.isHidden = false
            self.canRespons_tittle_txt.isUserInteractionEnabled = true
            navigation_title_lbl.text = "Create Response"
            self.canRespons_txv.text = ""
        }
        else
        {
            self.create_btn.isHidden = false
            self.canRespons_tittle_txt.isUserInteractionEnabled = false
            navigation_title_lbl.text = "Update Response"
            self.create_btn.setTitle("Done", for: .normal)
            self.canRespons_tittle_txt.text = updateArray.value(forKey: "cannedResponseTitle") as? String
            self.canRespons_txv.text = updateArray.value(forKey: "cannedResponseDesc") as? String
         
        }
        for i in 0..<self.getrolebyorganizationArray.count
        {
             let roleDic: NSDictionary = getrolebyorganizationArray?[i] as! NSDictionary
             let role: String = roleDic.value(forKey: "team_id") as! String
            if(getTeamId == role)
            {
                getorg_id = roleDic.value(forKey: "organization_id") as? String
                getSport_id = roleDic.value(forKey: "sport_id") as? String
                season_id = roleDic.value(forKey: "season_id") as? String
            }
        }
        
        canRespons_txv.layer.borderColor = UIColor.black.cgColor
        canRespons_txv.layer.borderWidth = 1.0
        canRespons_txv.layer.masksToBounds = true
        getuserDetail()
    }
    func getuserDetail()
    {
        self.orderviewheight.constant = (self.getorderArray.count > 5) ? 90 : 50

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
            selectOption_btn.titleLabel?.font = UIFont(name: "Arial", size: 18)
            let title: String = getorderArray?[i] as! String

            if(title != "" && title != nil)
            {
            if(i == 0)
            {
                selectOption_btn.setTitle("\(getorderArray[i] as! String)", for: .normal)
            }
            else
            {
              selectOption_btn.setTitle("> \(getorderArray[i] as! String)", for: .normal)

            }
           // selectOption_btn.setTitle("\(getorderArray[i] as! String)", for: .normal)
            selectOption_btn.translatesAutoresizingMaskIntoConstraints = false
            let attrStr = NSMutableAttributedString(string: "\(selectOption_btn.title(for: .normal) ?? "")")
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
        }
       
        self.SelectorderView.addSubview(addOrderView)
        orderviewheight.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 90 : 50

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        //canRespons_txv.backgroundColor = UIColor.lightGray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       // canRespons_txv.backgroundColor = UIColor.white
    }
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text);
        let canresponsdesc = (isCreate == true) ? "" : updateArray.value(forKey: "cannedResponseDesc") as? String
        
        if(textView.text == canresponsdesc)
               {
                  create_btn.isUserInteractionEnabled = false
                   create_btn.setTitleColor(UIColor.darkGray, for: .normal)
               }
               else
               {
                   create_btn.isUserInteractionEnabled = true
                   create_btn.setTitleColor(UIColor.blue, for: .normal)
               }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         print("textFieldShouldBeginEditing")
         return true
     }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == self.canRespons_tittle_txt.text)
        {
           create_btn.isUserInteractionEnabled = false
            create_btn.setTitleColor(UIColor.darkGray, for: .normal)
        }
        else
        {
            create_btn.isUserInteractionEnabled = true
            create_btn.setTitleColor(UIColor.blue, for: .normal)
        }
         print("textField")
         print("Leaving textField")
         return true
     }
    
   
    func textFieldDidEndEditing(_ textField: UITextField) {
         print("textFieldDidEndEditing")
        print("textField = \(textField.text ?? "")")
         print("Leaving textFieldDidEndEditing")
     }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if(textField == canRespons_tittle_txt)
        {
            create_btn.isUserInteractionEnabled = false
            create_btn.tintColor = UIColor.darkGray
        }
        else
        {
           create_btn.isUserInteractionEnabled = true
            create_btn.tintColor = UIColor.blue
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return true
    }
    
    @objc func orderselectmethod(_ sender: UIButton)
    {
        self.delegate?.passorderArray(select: self.getorderArray,selectindex: sender)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func createCanResponse(_ sender: UIButton)
    {
        var ref: DocumentReference? = nil
         var refuserid: String!
        if(isCreate == true)
        {
            if(canRespons_tittle_txt.text == nil || canRespons_tittle_txt.text?.isEmpty == true)
            {
                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter Canned Response Tiltle")
            }
            else
            {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
         
               let docRef = db.collection("teams").document("\(getTeamId!)")
                docRef.collection("CannedResponse").getDocuments() { (querySnapshot, err) in
                           if let err = err {
                               print("Error getting documents: \(err)")
                           } else {
                                 let getcannedList = NSMutableArray()
                            if(getcannedList.count == 0)
                            {
                                ref =  docRef.collection("CannedResponse").addDocument(data: ["count" : 0, "created_datetime": Date(),"created_uid" : "\(getuuid!)", "cannedResponseTitle": "\(self.canRespons_tittle_txt.text!)","cannedResponseDesc":"\(self.canRespons_txv.text!)","canned_response_description": "\(self.canRespons_txv.text!)", "updated_datetime" : Date(),"organization_id": "\(self.getorg_id!)","sport_id": "\(self.getSport_id!)","team_id":"\(self.getTeamId!)","is_used": false,"updated_uid":""])
                                        
                            { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                    
                                     Constant.showInActivityIndicatory()
                                    //print("Shopping List Item Document added with ID: \(ref!.documentID)")
                                    docRef.collection("CannedResponse").document(ref!.documentID).updateData(["cannedResponseTitle_id":ref!.documentID])
                                                            if let err = err {
                                                                   print("Error writing document: \(err)")
                                                            } else {
                                                                
                                                                refuserid = ref?.documentID
                                                                let useRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(self.rolebySeasonid!)")
                                                                useRef.collection("CannedResponse").document("\(refuserid!)").setData(["count" : 0, "created_datetime": Date(),"created_uid" : "\(getuuid!)", "cannedResponseTitle": "\(self.canRespons_tittle_txt.text!)","cannedResponseDesc":"\(self.canRespons_txv.text!)","canned_response_description": "\(self.canRespons_txv.text!)", "updated_datetime" : Date(),"organization_id": "\(self.getorg_id!)","sport_id": "\(self.getSport_id!)","team_id":"\(self.getTeamId!)","is_used": false,"cannedResponseTitle_id":"\(refuserid!)"])
                                                                { err in
                                                                    if let err = err {
                                                                    print("Error writing document: \(err)")
                                                                                                       } else {
                                                                    print("Team Document successfully written!")
                                                                
                                                                                                               
                                                Constant.showInActivityIndicatory()
                                            self.alertermsg(msg: "Canned Response created successfully ")
                                                            
                                                                                                           }
                                                                                                   
                                                                                                   }
 

                                                            }
                                    
                                }
                                Constant.showInActivityIndicatory()
                            }
                            }
                            else
                            {
                                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "This CannedResponse Already exit")
                                Constant.showInActivityIndicatory()
                            }
            }
                    
                    
        }
            }
        }
        else
        {
                 Constant.internetconnection(vc: self)
                 Constant.showActivityIndicatory(uiView: self.view)
                 let getuuid = UserDefaults.standard.string(forKey: "UUID")
                 let db = Firestore.firestore()
            let teamRef = db.collection("teams").document("\(getTeamId!)")
                      
            teamRef.collection("CannedResponse").document("\(updateArray.value(forKey: "cannedResponseTitle_id") as! String)").updateData(["cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date()])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    Constant.showInActivityIndicatory()

                } else {
                    print("Document successfully updated")
                     Constant.showInActivityIndicatory()
                    let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(self.rolebySeasonid!)")
                    docRef.collection("CannedResponse").document("\(self.updateArray.value(forKey: "cannedResponseTitle_id") as! String)").updateData(["cannedResponseDesc":"\(self.canRespons_txv.text!)", "updated_datetime" : Date()])
                    { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                        Constant.showInActivityIndicatory()

                    } else {
                        Constant.showInActivityIndicatory()

                        self.alertermsg(msg: "Canned Response updated successfully ")

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
    
    
   // func deleteMethod()
//    {
//        Constant.internetconnection(vc: self)
//        Constant.showActivityIndicatory(uiView: self.view)
//        let getuuid = UserDefaults.standard.string(forKey: "UUID")
//        let db = Firestore.firestore()
//        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebySeasonid!)")
//        docRef.collection("CannedResponse").document("\(updateArray.value(forKey: "cannedResponseTitle")!)").delete()
//        { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//                let organizationId: NSDictionary = self.getrolebyorganizationArray?[0] as! NSDictionary
//                let docrefs = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document()
//                docrefs.collection("CannedResponse").document("\(self.updateArray.value(forKey: "cannedResponseTitle")!)").delete()
//                { err in
//                    if let err = err {
//                        print("Error removing document: \(err)")
//                    } else {
//                        print("Document successfully removed!")
//                         let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document().collection("seasons").document().collection("teams").document("\(self.getorderArray.lastObject!)")
//                        addDoc.collection("CannedResponse").document("\(self.updateArray.value(forKey: "cannedResponseTitle")!)").delete()
//                        { err in
//                            if let err = err {
//                                print("Error removing document: \(err)")
//                            } else {
//                                print("Document successfully removed!")
//                                Constant.showInActivityIndicatory()
//                                self.alertermsg(msg: "\(self.updateArray.value(forKey: "cannedResponseTitle")!) deleted successfully")
////                                self.delegate?.createAfterCallMethod()
////                                self.navigationController?.popViewController(animated: false)
//                            }
//                        }
//
//                    }
//
//                }
//                Constant.showInActivityIndicatory()
//
//
//            }
//        }
//    }
   // @IBAction func deleteGroup_Method(_ sender: UIButton)
//       {
////           let indexno = sender.tag
////           let teamDic: NSDictionary = self.updateArray?[indexno] as! NSDictionary
//           let count : Int = updateArray.value(forKey: "count") as! Int
//           let isDelete: Bool = (count > 0 ) ? false : true
//           if(isDelete == false)
//           {
//               Constant.showAlertMessage(vc: self, titleStr: "Unable To Delete", messageStr: "System user group can't able to delete")
//           }
//           else
//           {
//            let alert = UIAlertController(title: " Delete User Group? ", message: "Are you sure want to delete \(canRespons_tittle_txt.text!)", preferredStyle: UIAlertController.Style.alert);
//               alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { _ in
//                          //Cancel Action
//                      }))
//               alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { _ in
//                   self.deleteMethod()
//                }))
//
//               self.present(alert, animated: true, completion: nil)
//
//
//           }
//
//       }
    @IBAction func cancelbtn(_ sender: UIButton)
    {
      self.navigationController?.popViewController(animated: true)
    }
    
}
