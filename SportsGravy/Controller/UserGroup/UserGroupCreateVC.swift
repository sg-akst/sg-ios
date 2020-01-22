//
//  UserGroupCreateVC.swift
//  SportsGravy
//
//  Created by CSS on 20/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

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
    weak var delegate:CreateusergroupDelegate?
    @IBOutlet weak var SelectorderView: UIView!
    @IBOutlet weak var group_tittle_txt: UITextField!
    @IBOutlet weak var groupcreate_btn: UIButton!
    @IBOutlet weak var groubdelete_btn: UIButton!
    @IBOutlet var group_create_tbl: UITableView!

     var groubSection: [GroupSection]!
     var selectpersonArray = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        group_tittle_txt.delegate = self
        group_create_tbl.delegate = self
        group_create_tbl.dataSource = self
        getuserDetail()
       
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: group_tittle_txt.frame.height - 1, width: self.view.frame.width-40, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        group_tittle_txt.borderStyle = UITextBorderStyle.none
        group_tittle_txt.layer.addSublayer(bottomLine)
        if(isCreate == true)
        {
          self.groubdelete_btn.isHidden = true
          self.groupcreate_btn.isHidden = false
          self.group_tittle_txt.isUserInteractionEnabled = true
                   
        }
        else
        {
            self.groubdelete_btn.isHidden = false
            self.groupcreate_btn.isHidden = false
            self.group_tittle_txt.isUserInteractionEnabled = false
            self.groupcreate_btn.setTitle("UPDATE", for: .normal)
            self.group_tittle_txt.text = self.updateArray.value(forKey: "display_name") as? String
        }
        getGroupDetailMethod()
       group_create_tbl.allowsMultipleSelection = true
        group_create_tbl.tableFooterView = UIView()
       

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
        if(dics.value(forKey: "user_id") as! String == dic.value(forKey: "user_id") as! String)
        {
            cell.checkbox.backgroundColor =  UIColor.green
            self.selectpersonArray.append(dics)

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

        return header
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let section = groubSection[indexPath.section]
            section.userlist.removeObject(at: indexPath.item)
            tableView.reloadData()
        }
    }
    @objc func selectplayer(_ sender: UIButton)
    {
        print(sender.tag)
        let button = sender
        let cell = button.superview?.superview as? UsergroupCreateCell
        let indexPaths = group_create_tbl.indexPath(for: cell!)
        let dicvalu = groubSection![indexPaths!.section]
        print(dicvalu)
        
       if cell?.checkbox.backgroundColor == UIColor.green
        {
            cell?.checkbox.backgroundColor = UIColor.clear
            self.selectpersonArray.remove(at: button.tag)
        }
        else
       {
        cell?.checkbox.backgroundColor = UIColor.green
        let getvalue: NSMutableDictionary = dicvalu.userlist[0] as! NSMutableDictionary

        self.selectpersonArray.append(getvalue)
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
                let alert = UIAlertController(title: " Delete User Group ", message: "Are you sure want to delete \(updateArray.value(forKey: "display_name")!)", preferredStyle: UIAlertController.Style.alert);
                   alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { _ in
                              //Cancel Action
                          }))
                   alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { _ in
                    self.deleteMethod()
                    }))
                   
                   self.present(alert, animated: true, completion: nil)
                   
                   
               }

           }
    func deleteMethod()
       {
           Constant.internetconnection(vc: self)
                Constant.showActivityIndicatory(uiView: self.view)
                let getuuid = UserDefaults.standard.string(forKey: "UUID")
                let db = Firestore.firestore()
                let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebySeasonid!)")
                docRef.collection("MemberGroup").document("\(updateArray.value(forKey: "user_groupId")!)").delete()
                { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                       let organizationId: NSDictionary = self.getrolebyorganizationArray?[0] as! NSDictionary
                        let docrefs = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document()
                        docrefs.collection("MemberGroup").document("\(self.updateArray.value(forKey: "user_groupId")!)").delete()
                        { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                               let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                                addDoc.collection("MemberGroup").document("\(self.updateArray.value(forKey: "user_groupId")!)").delete()
                                { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                        Constant.showInActivityIndicatory()
                                       // Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "MemberGroup Removed Successfully")
                                        //self.getmembergroup()
                                        self.delegate?.createAfterCallMethod()
                                    }
                                }

                            }

                        }
                        Constant.showInActivityIndicatory()


                    }
                }
           }
    
    @IBAction func Create_BtnAction(_ sender: UIButton)
    {
        if(isCreate == true)
        {
            Constant.internetconnection(vc: self)
            Constant.showActivityIndicatory(uiView: self.view)
            let getuuid = UserDefaults.standard.string(forKey: "UUID")
            let db = Firestore.firestore()
            let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebySeasonid!)")
            docRef.collection("MemberGroup").document("\(group_tittle_txt.text!)").setData(["count" : 0, "created_datetime": Date().timeIntervalSince1970,"created_uid" : "\(getuuid!)", "display_name": "\(group_tittle_txt.text!)","group_type" : "Custom_Group", "updated_datetime" : Date().timeIntervalSince1970, "updated_uid" : "", "user_groupId": "\(group_tittle_txt.text!)","user_list" : self.selectpersonArray] )
            { err in
                    if let err = err {
                           print("Error writing document: \(err)")
                    } else {
                    print("Document successfully written!")
                    let organizationId: NSDictionary = self.getrolebyorganizationArray?[0] as! NSDictionary
                    let docrefs = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)")
                        docrefs.collection("MemberGroup").document("\(self.group_tittle_txt.text!)").setData(["count" : 0, "created_datetime": Date().timeIntervalSince1970,"created_uid" : "\(getuuid!)", "display_name": "\(self.group_tittle_txt.text!)", "updated_datetime" : Date().timeIntervalSince1970, "updated_uid" : "", "group_type": "Custom_Group", "user_groupId" : "\(self.group_tittle_txt.text!)", "user_list": self.selectpersonArray] )
                    { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        } else {
                    print("Document successfully written!")
                    print(self.getorderArray.lastObject!)
                    let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                        addDoc.collection("MemberGroup").document("\(self.group_tittle_txt.text!)").setData(["count" : 0, "created_datetime": Date().timeIntervalSince1970,"created_uid" : "\(getuuid!)", "display_name": "\(self.group_tittle_txt.text!)", "updated_datetime" : Date().timeIntervalSince1970, "updated_uid" : "", "user_groupId": "\(self.group_tittle_txt.text!)", "user_list" : self.selectpersonArray] )
                        { err in
                            if let err = err {
                                           print("Error writing document: \(err)")
                        } else {
                        print("Document successfully written!")
                        Constant.showInActivityIndicatory()
                                    
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
            docRef.collection("MemberGroup").document("\(updateArray.value(forKey: "display_name") as! String)").updateData(["user_list": selectpersonArray, "updated_datetime" : Date().timeIntervalSince1970])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    Constant.showInActivityIndicatory()

                } else {
                    print("Document successfully updated")
                    let organizationId: NSDictionary = self.getrolebyorganizationArray?[0] as! NSDictionary
                    let docrefs = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)")
                    
                    docrefs.collection("MemberGroup").document("\(self.updateArray.value(forKey: "display_name") as! String)").updateData(["user_list": self.selectpersonArray, "updated_datetime" : Date().timeIntervalSince1970])
                    { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                            Constant.showInActivityIndicatory()

                        } else {
                            print("Document successfully updated")
                            let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                            addDoc.collection("MemberGroup").document("\(self.updateArray.value(forKey: "display_name") as! String)").updateData(["user_list": self.selectpersonArray, "updated_datetime" : Date().timeIntervalSince1970])
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
    
    
        @IBAction func cancelbtn(_ sender: UIButton)
        {
          self.navigationController?.popViewController(animated: true)
        }
    
    
}
