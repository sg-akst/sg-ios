
import UIKit
import SWRevealViewController
import Firebase
import FirebaseFirestoreSwift

protocol CreateusergroupDelegate: AnyObject {
    func passorderArray(select:NSMutableArray!, selectindex: UIButton)
    func createAfterCallMethod()

}
struct GroupSection {
    let title: String
    let userlist: NSMutableArray
}

class UserGroupCreateVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var getorderArray: NSMutableArray!
    var updateArray: NSDictionary!
    var addOrderView: UIView!
    var isCreate: Bool!
    var rolebySeasonid: String!
    var getrolebyorganizationArray: NSMutableArray!
    var selectOption_btn: UIButton!
    var getTeamId: String!
    var getGroupDetails: NSMutableArray!
    
    var getorg_id: String!
    var getSport_id: String!
    var season_id: String!
    var people_id: String!
    var user_groupId: String!
    
    weak var delegate:CreateusergroupDelegate?
    @IBOutlet weak var SelectorderView: UIView!
    @IBOutlet weak var group_tittle_txt: UITextField!
    @IBOutlet weak var groupcreate_btn: UIButton!
    @IBOutlet var group_create_tbl: UITableView!
    @IBOutlet var navigation_title_lbl: UILabel!
    @IBOutlet weak var orderviewheight: NSLayoutConstraint!
   


     var groubSection: [GroupSection]!
    var selectpersonArray: NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        group_tittle_txt.delegate = self
        group_create_tbl.delegate = self
        group_create_tbl.dataSource = self
        
        selectpersonArray = NSMutableArray()
        getuserDetail()
       
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: -10.0, y: group_tittle_txt.frame.height, width: self.view.frame.width, height: 0.3)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        group_tittle_txt.borderStyle = UITextBorderStyle.none
        group_tittle_txt.layer.addSublayer(bottomLine)
        if(isCreate == true)
        {
          //self.groubdelete_btn.isHidden = true
          self.groupcreate_btn.isHidden = false
          self.group_tittle_txt.isUserInteractionEnabled = true
            navigation_title_lbl.text = "Create User Group"
                   
        }
        else
        {
            //self.groubdelete_btn.isHidden = false
            self.groupcreate_btn.isHidden = false
            self.group_tittle_txt.isUserInteractionEnabled = false
            self.groupcreate_btn.setTitle("Done", for: .normal)
             navigation_title_lbl.text = "Update User Group"
            self.group_tittle_txt.text = "\(self.updateArray.value(forKey: "display_name")!)"
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
        
        getGroupDetailMethod()
       group_create_tbl.allowsMultipleSelection = true
        group_create_tbl.tableFooterView = UIView()
        self.group_create_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        group_create_tbl.sizeToFit()
       

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
               //selectOption_btn.setTitle("\(getorderArray[i] as! String)", for: .normal)
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
                           
                   }
                   else{
                       // put it in new line
                       let previousLeftmostButton: UIButton = buttons.object(at: indexOfLeftmostButtonOnCurrentLine) as! UIButton

                       // horizontal position: same as previous leftmost button (on line above)
                       let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: selectOption_btn, attribute: .left, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .left, multiplier: 1.0, constant: 0.0)
                       self.addOrderView.addConstraint(horizontalConstraint)


                       // vertical position:
                       let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: selectOption_btn, attribute: .top, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .bottom, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                       self.addOrderView.addConstraint(verticalConstraint)
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
       }
       @objc func orderselectmethod(_ sender: UIButton)
       {
           self.delegate?.passorderArray(select: self.getorderArray,selectindex: sender)
           self.navigationController?.popViewController(animated: true)
       }
    
    func getGroupDetailMethod()
    {
        let groupaddArray: NSMutableArray = NSMutableArray()
        
        for i in 0..<self.getGroupDetails.count
        {
            let data: NSMutableDictionary = getGroupDetails[i] as! NSMutableDictionary
            let typeofgroub: String = data.value(forKey: "group_type") as! String
            if(typeofgroub == "System_Group")
            {
                let group = GroupSection.init(title: data.value(forKey: "display_name") as! String, userlist: (data.value(forKey: "user_list") as? NSMutableArray)!)
                groupaddArray.add(group)
                
            }
            
        }
        
        groubSection = groupaddArray as? [GroupSection]
        print("section=> \(groubSection!)")
                
    }
    
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return groubSection.count
    }
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return groubSection[section].userlist.count
    }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UsergroupCreateCell  = tableView.dequeueReusableCell(withIdentifier: "groupCreate", for: indexPath) as! UsergroupCreateCell
      let section = groubSection[indexPath.section]
    let dic: NSDictionary = section.userlist[indexPath.row] as! NSDictionary
    cell.member_name_lbl.text = "\(dic.value(forKey: "first_name")!)" + "" + "\(dic.value(forKey: "last_name")!)"
    cell.checkbox.layer.cornerRadius = cell.checkbox.frame.size.width/2
    cell.checkbox.layer.masksToBounds = true
    cell.checkbox.layer.borderWidth = 3
    cell.checkbox.layer.borderColor = Constant.getUIColor(hex: "#C0CCDA")?.cgColor
    cell.checkbox.backgroundColor =  UIColor.clear
    cell.checkbox.tag = indexPath.section
    cell.checkbox.addTarget(self, action: #selector(selectplayer), for: .touchUpInside)
    if(isCreate == false)
    {
    let userSelectArray: NSMutableArray = updateArray.value(forKey: "user_list") as! NSMutableArray
    
    for i in 0..<userSelectArray.count
    {
        let dics: NSMutableDictionary = userSelectArray[i] as! NSMutableDictionary
        if(dics.value(forKey: "user_id") as! String == dic.value(forKey: "user_id") as! String && dic.value(forKey: "role") as! String == dics.value(forKey: "role") as! String)
        {
            cell.checkbox.backgroundColor =  UIColor.green
            let selectpersonDic: NSDictionary = dics.copy() as! NSDictionary
            self.selectpersonArray.add(selectpersonDic)

        }
    }
    }
   return cell
   }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 44.0
   }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? GroubHeaderCell
        let section = groubSection[section].title
        header?.header_title_lbl?.text = "\(section)"
        return header?.contentView
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
          print("textFieldShouldBeginEditing")
          return true
      }
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if(string == "")
         {
            groupcreate_btn.isUserInteractionEnabled = false
             groupcreate_btn.setTitleColor(UIColor.darkGray, for: .normal)
         }
         else
         {
             groupcreate_btn.isUserInteractionEnabled = true
             groupcreate_btn.setTitleColor(UIColor.blue, for: .normal)
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
    @objc func selectplayer(_ sender: UIButton)
    {
        print(sender.tag)
        let button = sender
        let cell = button.superview?.superview as? UsergroupCreateCell
        let indexPaths = group_create_tbl.indexPath(for: cell!)
        let dicvalu = groubSection![indexPaths!.section]
        let getuserlist: NSMutableDictionary = dicvalu.userlist[0] as! NSMutableDictionary
        let getvalue: NSDictionary = getuserlist.copy() as! NSDictionary
        print(dicvalu)
        
       if cell?.checkbox.backgroundColor == UIColor.green
        {

              cell?.checkbox.backgroundColor = UIColor.clear

                for i in 0..<self.selectpersonArray.count
            {
                if(self.selectpersonArray.count > i)
                {
                let dic: NSDictionary = self.selectpersonArray[i] as! NSDictionary
                
                    if(getvalue.value(forKey: "user_id") as! String  == dic.value(forKey: "user_id") as! String  && getvalue.value(forKey: "role")as! String == dic.value(forKey: "role") as! String)
                {
                    self.selectpersonArray.removeObject(at: i)

                }
                }
            }

       }
        else
       {
        cell?.checkbox.backgroundColor = UIColor.green
        self.selectpersonArray.add(getvalue)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("You tapped cell number \(indexPath.section).")
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example

        let currentCell = tableView.cellForRow(at: indexPath!) as! UsergroupCreateCell

        if(currentCell.isSelected)
        {
            currentCell.checkbox.backgroundColor = UIColor.green

        }
        else
        {
            currentCell.checkbox.backgroundColor = UIColor.clear
           
        }

    }
    
   
    @IBAction func Create_BtnAction(_ sender: UIButton)
    {
        var ref: String!
        var teamref : DocumentReference? = nil

        if(isCreate == true)
        {
            if(group_tittle_txt.text == nil || group_tittle_txt.text?.isEmpty == true)
            {
                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please enter user group name")
            }
            else if(self.selectpersonArray.count == 0)
            {
                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please select user to create custom group")
            }
            else
            {
             
                
            Constant.internetconnection(vc: self)

            let getuuid = UserDefaults.standard.string(forKey: "UUID")
            let db = Firestore.firestore()
                Constant.showActivityIndicatory(uiView: self.view)
                let teamRef = db.collection("teams").document("\(self.getTeamId!)")

              teamRef.collection("MemberGroup").getDocuments() { (querySnapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                    let getusergroup = NSMutableArray()

                      for document in querySnapshot!.documents {
                      let data: NSDictionary = document.data() as NSDictionary
                        if(data.value(forKey: "display_name") as! String == self.group_tittle_txt.text! || (data.value(forKey: "display_name") as! String) . caseInsensitiveCompare(self.group_tittle_txt.text!) == ComparisonResult.orderedSame)
                        {
                            getusergroup.add(data)

                        }
                     }
                
                if(getusergroup.count == 0)
                {

                    teamref = teamRef.collection("MemberGroup").addDocument(data: ["count" : 0, "created_datetime": Date(),"created_uid" : "\(getuuid!)", "display_name": "\(self.group_tittle_txt.text!)","group_type" : "Custom_Group", "updated_datetime" : Date(), "updated_uid" : "","user_list" : self.selectpersonArray, "organization_id": "\(self.getorg_id!)","season_id": "\(self.season_id!)", "sport_id": "\(self.getSport_id!)", "is_used": false])
                    { err in
                                        if let err = err {
                                               print("Error writing document: \(err)")
                                        } else {
                                        print("Document successfully written!")
                                            Constant.showInActivityIndicatory()
                    teamRef.collection("MemberGroup").document(teamref!.documentID).updateData(["user_groupId":teamref!.documentID])
                                            if let err = err {
                                                   print("Error writing document: \(err)")
                                            } else {
                                                ref = teamref?.documentID
                                                let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(self.rolebySeasonid!)")
                                                docRef.collection("MemberGroup").document("\(ref!)").setData(["count" : 0, "created_datetime": Date(),"created_uid" : "\(getuuid!)", "display_name": "\(self.group_tittle_txt.text!)","group_type" : "Custom_Group", "updated_datetime" : Date(), "updated_uid" : "","user_list" : self.selectpersonArray, "organization_id": "\(self.getorg_id!)","season_id": "\(self.season_id!)", "sport_id": "\(self.getSport_id!)","is_used": false,"user_groupId":"\(ref!)"])
                                    { err in
                                        if let err = err {
                                        print("Error writing document: \(err)")
                                                                           } else {
                                        print("Team Document successfully written!")
                                    self.alertermsg(msg: "User group created successfully ")
//docRef.collection("MemberGroup").document(ref).updateData(["user_groupId":ref])
//                                            if let err = err {
//                                        print("Error writing document: \(err)")
//                                        } else {
                                                                                   
                                                          //  }
                                                                               }
                                                                       
                                                                       }
                                                                   }
                                                
                                                
                                                Constant.showInActivityIndicatory()
                                            }

                                           }
                                           Constant.showInActivityIndicatory()
                                       }
                else
                {
                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "This UserGroup Already exit")
                    Constant.showInActivityIndicatory()

                }
                     
                      }
                  }
            }
        }
        else
        {
            if(self.selectpersonArray.count == 0)
            {
                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Please select user to update custom group")
            }
            else
           {
           Constant.internetconnection(vc: self)
                 Constant.showActivityIndicatory(uiView: self.view)
                 let getuuid = UserDefaults.standard.string(forKey: "UUID")
                 let db = Firestore.firestore()
            let teamRef = db.collection("teams").document("\(self.getTeamId!)")
            teamRef.collection("MemberGroup").document("\(updateArray.value(forKey: "user_groupId") as! String)").updateData(["user_list": selectpersonArray, "updated_datetime" : Date()])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    Constant.showInActivityIndicatory()

                } else {
                    print("Document successfully updated")
                    let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(self.rolebySeasonid!)")
            docRef.collection("MemberGroup").document("\(self.updateArray.value(forKey: "user_groupId") as! String)").updateData(["user_list": self.selectpersonArray, "updated_datetime" : Date()])
                    { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                        Constant.showInActivityIndicatory()

                    } else {
                        
                        Constant.showInActivityIndicatory()
                        self.alertermsg(msg: "User group updated successfully ")
                                           
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
