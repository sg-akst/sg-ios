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
import Crashlytics

protocol PassSelectorderDelegate: AnyObject {
    func selectorderArray(select:NSMutableArray!,selectindex: UIButton)
    func createAfterCallMethod()
}

class TagCreateVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var SelectorderView: UIView!
    @IBOutlet weak var tag_txt: UITextField!
    @IBOutlet weak var create_btn: UIButton!
    var rolebySeasonid: String!
    var getrolebyorganizationArray: NSMutableArray!
    var getTeamId: String!
    var getorg_id: String!
    var getSport_id: String!
    
    @IBOutlet weak var orderviewheight: NSLayoutConstraint!


    weak var delegate:PassSelectorderDelegate?

    
    var getorderArray: NSMutableArray!
    var addOrderView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tag_txt.delegate = self
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -20.0, y: tag_txt.frame.height - 1, width: self.view.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        tag_txt.borderStyle = UITextBorderStyle.none
        tag_txt.layer.addSublayer(bottomLine)
       // let dic: NSDictionary = getrolebyorganizationArray?[0] as! NSDictionary
       // print(dic)
        for i in 0..<self.getrolebyorganizationArray.count
        {
             let roleDic: NSDictionary = getrolebyorganizationArray?[i] as! NSDictionary
             let role: String = roleDic.value(forKey: "team_id") as! String
            if(getTeamId == role)
            {
                getorg_id = roleDic.value(forKey: "organization_id") as? String
                getSport_id = roleDic.value(forKey: "sport_id") as? String
            }
        }
        
        getuserDetail()
    }
    
    func getuserDetail()
    {
         //self.orderviewheight.constant = (self.getorderArray.count > 5) ? 90 : 50
        let buttons: NSMutableArray = NSMutableArray()
        var indexOfLeftmostButtonOnCurrentLine: Int = 0
        var runningWidth: CGFloat = 0.0
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let horizontalSpaceBetweenButtons: CGFloat = 8.0
        let verticalSpaceBetweenButtons: CGFloat = 1.5
        self.addOrderView = UIView()
        self.addOrderView.frame = self.SelectorderView.bounds
        for i in 0..<self.getorderArray.count
        {            
            let button: UIButton = UIButton(type: .roundedRect)
            button.titleLabel?.font = UIFont(name: "Arial", size: 18)
            button.titleLabel?.textAlignment = .left
            let title: String = getorderArray?[i] as! String

            if(title != "" && title != nil)
            {
            if(i == 0)
            {
                button.setTitle("\(getorderArray[i] as! String)", for: .normal)
            }
            else
            {
              button.setTitle("> \(getorderArray[i] as! String)", for: .normal)

            }
            //button.setTitle("\(getorderArray[i] as! String)", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            let attrStr = NSMutableAttributedString(string: "\(button.title(for: .normal) ?? "")")
            if(i != 0)
            {
                attrStr.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 2))
            }
            button.setAttributedTitle(attrStr, for: .normal)
            let lastIndex: Int = getorderArray.count-1
            
             if(lastIndex == i)
            {
             button.tintColor = UIColor.gray
             button.setTitleColor(UIColor.gray, for: .normal)
             button.isUserInteractionEnabled = false
             }
             else
            {
             button.tintColor = UIColor.blue
             button.setTitleColor(UIColor.blue, for: .normal)
             button.isUserInteractionEnabled = true

             }
            
            button.titleLabel?.textAlignment = .center
            button.sizeToFit()
            button.tag = i
            self.addOrderView.addSubview(button)
            button.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)
             if ((i == 0) || (runningWidth + button.frame.size.width > maxWidth)){
                 runningWidth = button.frame.size.width
                if(i==0)
                {
                    // first button (top left)
                    // horizontal position: same as previous leftmost button (on line above)
                   let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: self.addOrderView, attribute: .left, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                   button.setAttributedTitle(attrStr, for: .normal)
                    addOrderView.addConstraint(horizontalConstraint)
                    
                    // vertical position:
                    let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self.addOrderView, attribute: .top, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                    self.addOrderView.addConstraint(verticalConstraint)
                        
                      

                }
                else{
                    // put it in new line
                    let previousLeftmostButton: UIButton = buttons.object(at: indexOfLeftmostButtonOnCurrentLine) as! UIButton

                    // horizontal position: same as previous leftmost button (on line above)
                    let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .left, multiplier: 1.0, constant: 0.0)
                    self.addOrderView.addConstraint(horizontalConstraint)

                     
                    // vertical position:
                    let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .bottom, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                    self.addOrderView.addConstraint(verticalConstraint)

                   

                    indexOfLeftmostButtonOnCurrentLine = i
                }
            }
            else
            {
                runningWidth += button.frame.size.width + horizontalSpaceBetweenButtons;

                let previousButton: UIButton = buttons.object(at: i-1) as! UIButton
                           
                let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: previousButton, attribute: .right, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                self.addOrderView.addConstraint(horizontalConstraint)
                let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: previousButton, attribute: .top, multiplier: 1.0, constant: 0.0)
                self.addOrderView.addConstraint(verticalConstraint)
            }
            buttons.add(button)
            }
        }
       
        self.SelectorderView.addSubview(addOrderView)
        self.orderviewheight.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 70 : 40

    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
          print("textFieldShouldBeginEditing")
          return true
      }
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if(string == "")
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

        
         return true
     }
     func textFieldDidBeginEditing(_ textField: UITextField) {
        
     }

     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
         return true
     }
     
    @objc func orderselectmethod(_ sender: UIButton)
    {

        self.delegate?.selectorderArray(select: self.getorderArray,selectindex: sender)
        self.navigationController?.popViewController(animated: true)
  
    }
    @IBAction func createtag(_ sender: UIButton)
    {
        self.tag_txt.resignFirstResponder()

        var ref: DocumentReference? = nil
        var teamref: DocumentReference? = nil

        if(tag_txt.text == nil || tag_txt.text == "")
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please Enter Tag Name")
        }
        else {
            //Crashlytics.sharedInstance().crash()
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebySeasonid!)")
            
            docRef.collection("Tags").getDocuments() { (querySnapshot, err) in
                Constant.showInActivityIndicatory()

            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                  let getTagList = NSMutableArray()

                    for document in querySnapshot!.documents {
                    let data: NSDictionary = document.data() as NSDictionary
                      if(data.value(forKey: "tag_name") as! String == self.tag_txt.text! || (data.value(forKey: "tag_name") as! String) . caseInsensitiveCompare(self.tag_txt.text!) == ComparisonResult.orderedSame)
                      {
                          getTagList.add(data)

                      }
                   }
                if(getTagList.count == 0)
                {
                    ref = docRef.collection("Tags").addDocument(data: ["count" : 0, "created_datetime": Date(),"created_uid" : "\(getuuid!)","tag_name": "\(self.tag_txt.text!)", "updated_datetime" : Date(), "updated_uid" : "","organization_id": "\(self.getorg_id!)","sport_id": "\(self.getSport_id!)","is_used": false])
                 { err in
                     if let err = err {
                         print("Error writing document: \(err)")
                     } else {
                         print("Document successfully written!")
                     docRef.collection("Tags").document(ref!.documentID).updateData(["tag_id":ref!.documentID])
                         if let err = err {
                                print("Error writing document: \(err)")
                         } else {
                            
                            let teamRef = db.collection("teams").document("\(self.getTeamId!)")
                            teamRef.collection("Tags").getDocuments{ (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                
                                let getteamsTagList = NSMutableArray()

                                 for document in querySnapshot!.documents {
                                 let data: NSDictionary = document.data() as NSDictionary
                                    if(data.value(forKey: "tag_name") as? String == self.tag_txt.text! || (data.value(forKey: "tag_name") as? String)? . caseInsensitiveCompare(self.tag_txt.text!) == ComparisonResult.orderedSame)
                                   {
                                       getteamsTagList.add(data)

                                   }
                                }
                                if(getteamsTagList.count == 0)
                                {
                                    teamref = teamRef.collection("Tags").addDocument(data: ["count" : 0, "created_datetime": Date(),"created_uid" : "\(getuuid!)","tag_name": "\(self.tag_txt.text!)", "updated_datetime" : Date(), "updated_uid" : "","organization_id": "\(self.getorg_id!)","sport_id": "\(self.getSport_id!)","is_used": false])
                                    { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    } else {
                                        print("Team Document successfully written!")
                                        teamRef.collection("Tags").document(teamref!.documentID).updateData(["tag_id":teamref!.documentID])
                                        if let err = err {
                                               print("Error writing document: \(err)")
                                        } else {
                                            
                                        self.alertermsg(msg: "Tag Created Successfully ")
                                        }
                                        }
                                    }
                                }
                                
                                
                                }
                            }
                            
                         }

                     }
                   
                 }
                
                }
                else
                {
                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "This Tag Already Exist")
                    Constant.showInActivityIndicatory()
                }
              
                }
            }
            
        }
    }
    func alertermsg(msg: String)
        {
            let alert = UIAlertController(title: "SportsGravy", message: msg.capitalized, preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                self.delegate?.createAfterCallMethod()
                self.navigationController?.popViewController(animated: false)
                   }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    
    
        @IBAction func cancelbtn(_ sender: UIButton)
        {
          self.navigationController?.popViewController(animated: true)
        }
    

}
