//
//  UsergroupVC.swift
//  SportsGravy
//
//  Created by CSS on 13/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import SWRevealViewController
import Firebase
import FirebaseFirestore

class UsergroupVC: UIViewController, SWRevealViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, CreateusergroupDelegate {
    func passorderArray(select: NSMutableArray!, selectindex: UIButton) {
        self.addorderArray = select
        addTitle_btn.tag = selectindex.tag
        addTitle_btn.sendActions(for:  .touchUpInside)
        
    }
    
    func createAfterCallMethod() {
        getmembergroup()
    }
    
    
    
    @IBOutlet var addorderview: UIView!
    @IBOutlet weak var usergroup_tbl: UITableView!
    @IBOutlet weak var createGroupView: UIView!
    @IBOutlet weak var sortingUser: UIButton!


    var getRolebyreasonDetailArray: NSMutableArray!
    var getSameOrganization: NSMutableArray!
    var getdifferentOrganization: NSMutableArray!
    var getSameSportsArray: NSMutableArray!
    var getdifferentSportsArray: NSMutableArray!
    var getSameSeasonArray: NSMutableArray!
    var getdifferentSeasonArray: NSMutableArray!
    var addorderArray: NSMutableArray!
    var commonArray: [String]!
    var getTeamId: String!
    var isCreate : Bool!
    
    var getSelectRole: String!
    var getOrganization: String!
    var getSport: String!
    var getSeason: String!
    var yPos = CGFloat()
    var addOrder: UIView!
    var getrolebySeasonid: String!
    var TeamArray: NSMutableArray!
    var isTeam : Bool = false
    var addTitle_btn: UIButton!

   @IBOutlet weak var orderviewheight: NSLayoutConstraint!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.delegate = self
        usergroup_tbl.delegate = self
        usergroup_tbl.dataSource = self
        commonArray = NSMutableArray() as? [String]
        usergroup_tbl.tableFooterView = UIView()
        self.addorderArray = NSMutableArray()

        getorganization()
        getsportsmethod()
        getSeasonmethod()
        getTeammethod()
        getuserDetail()
        createGroupView.isHidden = true
        sortingUser.isHidden = true
        self.usergroup_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.usergroup_tbl.sizeToFit()

    }
    func getuserDetail()
    {
            let buttons: NSMutableArray = NSMutableArray()
            var indexOfLeftmostButtonOnCurrentLine: Int = 0
            var runningWidth: CGFloat = 10.0
            let maxWidth: CGFloat = 375.0
            let horizontalSpaceBetweenButtons: CGFloat = 5.0
            let verticalSpaceBetweenButtons: CGFloat = 5.0
            if(self.addOrder != nil)
            {
               self.addOrder.removeFromSuperview()
            }
            self.addOrder = UIView()
            self.addOrder.frame = self.addorderview.bounds
            for i in 0..<self.addorderArray.count
            {
                addTitle_btn = UIButton(type: .roundedRect)
    
                addTitle_btn.titleLabel?.font = UIFont(name: "Arial", size: 20)
                addTitle_btn.setTitle("\(addorderArray[i] as! String)", for: .normal)
                let title: String = addorderArray?[i] as! String
                addTitle_btn.translatesAutoresizingMaskIntoConstraints = false
                let attrStr = NSMutableAttributedString(string: "\(title)")
               
                if(i != 0)
                {
                    attrStr.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 1))
                }
               addTitle_btn.setAttributedTitle(attrStr, for: .normal)

                let lastIndex: Int = addorderArray.count-1
               
                if(lastIndex == i)
               {
                addTitle_btn.tintColor = UIColor.gray
                addTitle_btn.setTitleColor(UIColor.gray, for: .normal)
                addTitle_btn.isUserInteractionEnabled = false
                }
                else
               {
                addTitle_btn.tintColor = UIColor.blue
                addTitle_btn.setTitleColor(UIColor.blue, for: .normal)
                addTitle_btn.isUserInteractionEnabled = true

                }
                addTitle_btn.sizeToFit()
                addTitle_btn.tag = i
                self.addOrder.addSubview(addTitle_btn)
                addTitle_btn.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)
                if ((i == 0) || (runningWidth + addTitle_btn.frame.size.width > maxWidth))
                 {
                     runningWidth = addTitle_btn.frame.size.width
                    if(i==0)
                    {
                        // first button (top left)
                        // horizontal position: same as previous leftmost button (on line above)
                       let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .left, relatedBy: .equal, toItem: self.addOrder, attribute: .left, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                       addTitle_btn.setAttributedTitle(attrStr, for: .normal)
                        addOrder.addConstraint(horizontalConstraint)
                        
                        // vertical position:
                        let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .top, relatedBy: .equal, toItem: self.addOrder, attribute: .top, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                        self.addOrder.addConstraint(verticalConstraint)

                    }
                    else{
                        // put it in new line
                        let previousLeftmostButton: UIButton = buttons.object(at: indexOfLeftmostButtonOnCurrentLine) as! UIButton

                        // horizontal position: same as previous leftmost button (on line above)
                        let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .left, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .left, multiplier: 1.0, constant: 0.0)
                        self.addOrder.addConstraint(horizontalConstraint)

                            //[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
                       // [self.view addConstraint:horizontalConstraint];

                        // vertical position:
                        let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .top, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .bottom, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                        self.addOrder.addConstraint(verticalConstraint)

                        //[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:verticalSpaceBetweenButtons];
                        //[self.view addConstraint:verticalConstraint];

                        indexOfLeftmostButtonOnCurrentLine = i
                    }
                }
                else
                {
                    runningWidth += addTitle_btn.frame.size.width + horizontalSpaceBetweenButtons;

                    let previousButton: UIButton = buttons.object(at: i-1) as! UIButton  //[buttons objectAtIndex:(i-1)];

                               // horizontal position: right from previous button
                    let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .left, relatedBy: .equal, toItem: previousButton, attribute: .right, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                    self.addOrder.addConstraint(horizontalConstraint)
                        
                        //[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:horizontalSpaceBetweenButtons];
                              // [self.view addConstraint:horizontalConstraint];

                               // vertical position same as previous button
                    let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .top, relatedBy: .equal, toItem: previousButton, attribute: .top, multiplier: 1.0, constant: 0.0)
                    self.addOrder.addConstraint(verticalConstraint)

                        
                        //[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
                             //  [self.view addConstraint:verticalConstraint];
                }
                buttons.add(addTitle_btn)

                
            }
           
            self.addorderview.addSubview(addOrder)
            
             
            
            
            if(commonArray.count > 0)
            {
                commonArray.removeAll { $0 == "" }
                usergroup_tbl.reloadData()
//                let indexPath = IndexPath(row: 0, section: 0)
//                self.usergroup_tbl.scrollToRow(at: indexPath, at: .top, animated: false)

            }

        }
    func getorganization()
    {
        self.commonArray = NSMutableArray() as? [String]
        getSameOrganization = NSMutableArray()
        getdifferentOrganization = NSMutableArray()
        addorderArray.add("All")
        for i in 0..<self.getRolebyreasonDetailArray.count
        {
             let roleDic: NSDictionary = getRolebyreasonDetailArray?[i] as! NSDictionary
             let role: String = roleDic.value(forKey: "role") as! String
            if(role == self.getSelectRole as String)
            {
                getOrganization = roleDic.value(forKey: "organization_abbrev") as? String
                self.getSameOrganization.add(roleDic)
                
            }
            else
             {
                getdifferentOrganization.add(roleDic)
            }
        }
        let filteredEvents: [String] = self.getRolebyreasonDetailArray.value(forKeyPath: "@distinctUnionOfObjects.organization_abbrev") as! [String]
        self.commonArray.append(contentsOf: filteredEvents)
    }
    func getsportsmethod()
    {
        if(self.getdifferentOrganization.count < 1)
              {
                self.commonArray = NSMutableArray() as? [String]

                  self.addorderArray.add("> \(getOrganization!)")
                  self.getSameSportsArray = NSMutableArray()
                  self.getdifferentSportsArray = NSMutableArray()
                  
                  for i in 0..<getSameOrganization.count
                  {
                      let roleDic: NSDictionary = getSameOrganization?[i] as! NSDictionary
                      let role: String = roleDic.value(forKey: "organization_abbrev") as! String
                      if(role == getOrganization)
                      {
                          self.getSport = roleDic.value(forKey: "sport_id") as? String
                          getSameSportsArray.add(roleDic)
                          
                      }
                      else
                      {
                          getdifferentSportsArray.add(roleDic)
                      }
                  }
                let filteredEvents: [String] = self.getSameOrganization.value(forKeyPath: "@distinctUnionOfObjects.sport_id") as! [String]
                       self.commonArray.append(contentsOf: filteredEvents)
              }
    }
    func getSeasonmethod()
    {
        if(self.getdifferentSportsArray.count < 1)
               {
                   self.commonArray = NSMutableArray() as? [String]
                   self.addorderArray.add("> \(getSport!)")
                   self.getSameSeasonArray = NSMutableArray()
                   self.getdifferentSeasonArray = NSMutableArray()
                   for i in 0..<getSameSportsArray.count
                   {
                       let roleDic: NSDictionary = getSameSportsArray?[i] as! NSDictionary
                       let role: String = roleDic.value(forKey: "sport_id") as! String
                       if(role == getSport)
                       {
                           self.getSeason = roleDic.value(forKey: "season_label") as? String
                           getSameSeasonArray.add(roleDic)
                        getrolebySeasonid = roleDic.value(forKey: "role_by_season_id") as? String
                        //"@distinctUnionOfObjects.role_by_season_id") as! String)

                       }
                       else
                       {
                           getdifferentSeasonArray.add(roleDic)
                       }
                   }
               }
    }
    func getTeammethod()
    {
         if(getSameSeasonArray.count > 0)
                {
        //            self.commonArray = NSMutableArray()
        //            self.commonArray = getSameSeasonArray
                    self.addorderArray.add("> \(getSeason!)")
                    let filteredEvents: [String] = self.getSameSportsArray.value(forKeyPath: "@distinctUnionOfObjects.team_name") as! [String]
                  
                    self.commonArray.append(contentsOf: filteredEvents)
                    

                }
    }
    
    @objc func orderselectmethod(_ sender: UIButton)
    {
        let selecttag = sender.tag
        orderviewheight.constant = 50
        isTeam = false
        createGroupView.isHidden = true

        if(selecttag == 0)
        {
            print("All")
            self.addorderArray = NSMutableArray()

            getorganization()
            getuserDetail()
        }
        else if(selecttag == 1)
        {
            print("organization")
            self.addorderArray = NSMutableArray()

            getorganization()
            getsportsmethod()
            getuserDetail()

        }
        else if(selecttag == 2)
        {
            print("Sport")
            self.addorderArray = NSMutableArray()

            getorganization()
            getsportsmethod()
            getSeasonmethod()
            commonArray.append(self.getSeason)
            getuserDetail()

        }
        else if(selecttag == 3)
        {
            print("season")
            self.addorderArray.removeLastObject()
            getuserDetail()
        }
        else
        {
            print("Team")
            isTeam = true
            getuserDetail()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isTeam == false)
        {
         return self.commonArray.count
        }
        else
        {
            return self.TeamArray.count
        }
            }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if(isTeam == false)
               {
         return 40.0
        }
        else
        {
           return 90.0
        }
     }

            // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(isTeam == false)
        {
        let cell: UITableViewCell = self.usergroup_tbl.dequeueReusableCell(withIdentifier: "user")!
        cell.textLabel?.text = commonArray?[indexPath.row]
        cell.textLabel?.textColor = UIColor.blue
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
     
         return cell
         }
        else
        {
            let cell: UserGroupCell = self.usergroup_tbl.dequeueReusableCell(withIdentifier: "teamcell") as! UserGroupCell
            let dic: NSDictionary = TeamArray?[indexPath.row] as! NSDictionary
            let userArray: NSMutableArray = dic.value(forKey: "user_list") as! NSMutableArray
            let count : Int = dic.value(forKey: "count") as! Int
            let groupType : String = dic.value(forKey: "group_type") as! String
            cell.delete_enable_img.tag = indexPath.row
            cell.delete_enable_img.addTarget(self, action: #selector(deleteGroup_Method), for: .touchUpInside)
            var filtered = String ()

            for i in 0..<userArray.count
            {
                let dic: NSDictionary = userArray[i] as! NSDictionary
                let appendStr: String = "\(dic.value(forKey: "first_name")!)" + " " + "\(dic.value(forKey: "last_name")!)" as String
                if(i == userArray.count-1)
                {
                    filtered.append(appendStr)
                }
                else
                {
                    filtered.append(appendStr + ", ")
                }
            }
            cell.displayName_lbl?.text = dic.value(forKey: "display_name") as? String
            cell.delete_enable_img.tintColor = (count > 0 || groupType == "System_Group") ? UIColor.gray : UIColor.red
            cell.username_lbl?.text = "\(filtered)"
            cell.selectionStyle = .none
            cell.accessoryType =  (count > 0 || groupType == "System_Group") ? .none : .disclosureIndicator

                return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
       
        if(isTeam == false)
        {
        if(self.addorderArray.count < 4)
        {
        self.addorderArray = NSMutableArray()
        getorganization()
        getsportsmethod()
        getSeasonmethod()
        getTeammethod()
        getuserDetail()

        }

        else
        {
           print(getSeason)
           self.addorderArray.add(" > \(self.commonArray[indexPath.row])")
            getuserDetail()
           
            for i in 0..<self.getRolebyreasonDetailArray.count
            {
                 let roleDic: NSDictionary = getRolebyreasonDetailArray?[i] as! NSDictionary
                 let role: String = roleDic.value(forKey: "team_name") as! String
                if(self.commonArray[indexPath.row] == role)
                {
                    getrolebySeasonid = roleDic.value(forKey: "role_by_season_id") as? String
                    getTeamId = roleDic.value(forKey: "team_id") as? String

                }
            }
//
            orderviewheight.constant = 90
            if (UserDefaults.standard.bool(forKey: "1") == true)
            {
                sortingUser.isHidden = false

            }
            else
            {
                sortingUser.isHidden = true

            }
            getmembergroup()
        }
        }
        else
        {
            let dic: NSDictionary = TeamArray?[indexPath.row] as! NSDictionary
            //let userArray: NSMutableArray = dic.value(forKey: "user_list") as! NSMutableArray
            let count : Int = dic.value(forKey: "count") as! Int
            let groupType : String = dic.value(forKey: "group_type") as! String
            if(count > 0 || groupType == "System_Group")
            {
                
            }
            else
            {
           let vc = storyboard?.instantiateViewController(withIdentifier: "userGroup_create") as! UserGroupCreateVC
           vc.getorderArray = addorderArray
           vc.isCreate = false
           vc.delegate = self
            vc.updateArray = TeamArray?[indexPath.row] as? NSDictionary
           vc.rolebySeasonid = self.getrolebySeasonid
           vc.getrolebyorganizationArray = getSameOrganization
           vc.getTeamId = getTeamId
            
            vc.getGroupDetails = self.TeamArray
           self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @objc func deleteGroup_Method(_ sender: UIButton)
    {
        let indexno = sender.tag
        let teamDic: NSDictionary = self.TeamArray?[indexno] as! NSDictionary
        let count : Int = teamDic.value(forKey: "count") as! Int
        let groupType : String = teamDic.value(forKey: "group_type") as! String
        let isDelete: Bool = (count > 0 || groupType == "System_Group") ? false : true
        if(isDelete == false)
        {
            Constant.showAlertMessage(vc: self, titleStr: "Unable To Delete", messageStr: "Tag is tied with feed,so cant able to delete")
        }
        else
        {
            let alert = UIAlertController(title: " Delete User Group? ", message: "Are you sure want to delete \(teamDic.value(forKey: "display_name")!)", preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { _ in
                       //Cancel Action
                   }))
            alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { _ in
                self.deleteMethod(rolebyDic: teamDic)
                }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getmembergroup()
    {
        Constant.internetconnection(vc: self)
               Constant.showActivityIndicatory(uiView: self.view)
               let getuuid = UserDefaults.standard.string(forKey: "UUID")
                let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(getrolebySeasonid!)")
        
        if (UserDefaults.standard.bool(forKey: "1") == true)
        {
        
            docRef.collection("MemberGroup").order(by: "updated_datetime", descending: false).getDocuments() { (querySnapshot, err) in
                         if let err = err {
                             print("Error getting documents: \(err)")
                         } else {
                            self.TeamArray = NSMutableArray()

                             for document in querySnapshot!.documents {
                                 let data: NSDictionary = document.data() as NSDictionary
                                 print("\(document.documentID) => \(data)")
                                self.TeamArray.add(data)
                                
        
                            }
                            
                            self.isTeam = true
                            self.createGroupView.isHidden = false
                            self.usergroup_tbl.reloadData()
//                            let indexPath = IndexPath(row: 0, section: 0)
//                            self.usergroup_tbl.scrollToRow(at: indexPath, at: .top, animated: false)
                            Constant.showInActivityIndicatory()


                        }
                    }
        }
        else
        {
            docRef.collection("MemberGroup").order(by: "count", descending: true).getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                       self.TeamArray = NSMutableArray()

                                        for document in querySnapshot!.documents {
                                            let data: NSDictionary = document.data() as NSDictionary
                                            print("\(document.documentID) => \(data)")
                                           self.TeamArray.add(data)
                                       }
                                       self.isTeam = true
                                       self.createGroupView.isHidden = false
                                       self.usergroup_tbl.reloadData()
//                                        let indexPath = IndexPath(row: 0, section: 0)
//                                        self.usergroup_tbl.scrollToRow(at: indexPath, at: .top, animated: false)
                                       Constant.showInActivityIndicatory()

                                   }
                               }
        }
        
    }
    func deleteMethod(rolebyDic: NSDictionary)
    {
        Constant.internetconnection(vc: self)
             Constant.showActivityIndicatory(uiView: self.view)
             let getuuid = UserDefaults.standard.string(forKey: "UUID")
             let db = Firestore.firestore()
             let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(getrolebySeasonid!)")
             docRef.collection("MemberGroup").document("\(rolebyDic.value(forKey: "user_groupId")!)").delete()
             { err in
                 if let err = err {
                     print("Error removing document: \(err)")
                 } else {
                     print("Document successfully removed!")
                     let organizationId: NSDictionary = self.getRolebyreasonDetailArray?[0] as! NSDictionary
                     let docrefs = db.collection("organization").document("\(self.getrolebySeasonid!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)")
                     docrefs.collection("MemberGroup").document("\(rolebyDic.value(forKey: "user_groupId")!)").delete()
                     { err in
                         if let err = err {
                             print("Error removing document: \(err)")
                         } else {
                             print("Document successfully removed!")
                            let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                             addDoc.collection("MemberGroup").document("\(rolebyDic.value(forKey: "user_groupId")!)").delete()
                             { err in
                                 if let err = err {
                                     print("Error removing document: \(err)")
                                 } else {
                                     print("Document successfully removed!")
                                     Constant.showInActivityIndicatory()
                                     Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "MemberGroup Removed Successfully")
                                   
                                     self.getmembergroup()
                                 }
                             }

                         }

                     }
                     Constant.showInActivityIndicatory()


                 }
             }
        }
    @IBAction func createusergroup(_ sender: UIButton)
    {
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "userGroup_create") as! UserGroupCreateVC
        vc.getorderArray = addorderArray
        vc.isCreate = true
        vc.delegate = self
        vc.rolebySeasonid = self.getrolebySeasonid
        vc.getrolebyorganizationArray = getSameOrganization
        vc.getTeamId = self.getTeamId
        vc.getGroupDetails = self.TeamArray

        self.navigationController?.pushViewController(vc, animated: true)
    }
       
    @IBAction func cancelbtn(_ sender: UIButton)
    {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
//        self.revealViewController()?.dismiss(animated: true, completion: nil)
    }
    @IBAction func sortingUserBtn_Action(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "sorting") as! SortingVC
        vc.getorderArray = addorderArray
        vc.sortingOrderArray = self.TeamArray
        vc.getorganizationDetails = getRolebyreasonDetailArray
        vc.rolebySeasonid = self.getrolebySeasonid as NSString?
        vc.getTeamId = self.getTeamId as NSString?
        vc.selectType = "MemberGroup"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
