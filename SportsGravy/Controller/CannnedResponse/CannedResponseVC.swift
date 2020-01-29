//
//  CannedResponseVC.swift
//  SportsGravy
//
//  Created by CSS on 16/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import SWRevealViewController
import Firebase
import FirebaseFirestore



class CannedResponseVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SWRevealViewControllerDelegate,CreateCanresponseDelegate {
    func passorderArray(select: NSMutableArray!, selectindex: UIButton) {
        self.addorderArray = select
        addTitle_btn.tag = selectindex.tag
        addTitle_btn.sendActions(for:  .touchUpInside)
    }
    func createAfterCallMethod() {
        getCannedresponsegroup()
    }
    

    @IBOutlet var addorderview: UIView!
    @IBOutlet weak var canned_response_tbl: UITableView!
    @IBOutlet weak var createGroupView: UIView!
    @IBOutlet weak var sortingCanned: UIButton!


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
        canned_response_tbl.delegate = self
        canned_response_tbl.dataSource = self
        commonArray = NSMutableArray() as? [String]
        canned_response_tbl.tableFooterView = UIView()
        self.addorderArray = NSMutableArray()

        getorganization()
        getsportsmethod()
        getSeasonmethod()
        getTeammethod()
        getuserDetail()
        createGroupView.isHidden = true
        sortingCanned.isHidden = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func getuserDetail()
    {
        if(self.addOrder != nil)
        {
           self.addOrder.removeFromSuperview()
        }
        self.addOrder = UIView()
        self.addOrder.frame = self.addorderview.bounds
        for i in 0..<self.addorderArray.count
        {
            
            let frame1 = (i > 3) ? (addorderArray.firstObject != nil) ? CGRect(x: 10, y: 55, width: 70, height: 40 ) : CGRect(x: 0 + (i * 75), y: 10, width: 70, height: 40 ) : (addorderArray.firstObject != nil) ? CGRect(x: 10 + (i * 75), y: 10, width: 70, height: 40 ) : CGRect(x: 0 + (i * 75), y: 10, width: 70, height: 40 )
            addTitle_btn = UIButton(frame: frame1)
            addTitle_btn.setTitle("\(addorderArray[i] as! String)", for: .normal)
            let lastIndex: Int = addorderArray.count-1
            
            if(lastIndex == i)
           {
            addTitle_btn.setTitleColor(UIColor.gray, for: .normal)

            }
            else
           {
            addTitle_btn.setTitleColor(UIColor.blue, for: .normal)

            }
            
            addTitle_btn.titleLabel?.textAlignment = .center
            addTitle_btn.sizeToFit()
            addTitle_btn.tag = i
            self.addOrder.addSubview(addTitle_btn)
            addTitle_btn.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)

        }
       
        self.addorderview.addSubview(addOrder)
        if(commonArray.count > 0)
        {
            commonArray.removeAll { $0 == "" }
            canned_response_tbl.reloadData()

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
                    self.addorderArray.add(" > \(getSeason!)")
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
        else if(selecttag == 4)
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
           return 80.0
        }
     }

            // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(isTeam == false)
        {
        let cell: UITableViewCell = self.canned_response_tbl.dequeueReusableCell(withIdentifier: "can_respons_user")!
        cell.textLabel?.text = commonArray?[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
     
         return cell
         }
        else
        {
            let cell: UserGroupCell = self.canned_response_tbl.dequeueReusableCell(withIdentifier: "can_response_cell") as! UserGroupCell
            let dic: NSDictionary = TeamArray?[indexPath.row] as! NSDictionary
            let count : Int = dic.value(forKey: "count") as! Int
            cell.delete_enable_img.tag = indexPath.row
            cell.delete_enable_img.addTarget(self, action: #selector(deleteGroup_Method), for: .touchUpInside)
            cell.displayName_lbl?.text = dic.value(forKey: "cannedResponseDesc") as? String
            cell.delete_enable_img.tintColor = (count > 0 ) ? UIColor.gray : UIColor.red
            cell.username_lbl?.text = dic.value(forKey: "cannedResponseTitle") as? String
            cell.selectionStyle = .none
            cell.accessoryType =  (count > 0) ? .none : .disclosureIndicator

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
           self.addorderArray.add("> \(self.commonArray[indexPath.row])")
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
            if (UserDefaults.standard.bool(forKey: "3") == true)
                {
                    self.sortingCanned.isHidden = false

                }
            else
            {
                self.sortingCanned.isHidden = true

            }
            getCannedresponsegroup()
        }
        }
        else
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "can_response_create") as! CannedResponseCreateVC
            vc.getorderArray = addorderArray
            vc.isCreate = false
            vc.delegate = self
            vc.updateArray = self.TeamArray[indexPath.row] as? NSDictionary
            vc.rolebySeasonid = self.getrolebySeasonid
            vc.getrolebyorganizationArray = getSameOrganization
            vc.getTeamId = getTeamId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func deleteGroup_Method(_ sender: UIButton)
    {
        let indexno = sender.tag
        let teamDic: NSDictionary = self.TeamArray?[indexno] as! NSDictionary
        let count : Int = teamDic.value(forKey: "count") as! Int
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
                self.deleteMethod(rolebyDic: teamDic)
                                  }))
            
            self.present(alert, animated: true, completion: nil)
            
            
        }

    }
    func getCannedresponsegroup()
    {
        Constant.internetconnection(vc: self)
               Constant.showActivityIndicatory(uiView: self.view)
               let getuuid = UserDefaults.standard.string(forKey: "UUID")
                let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(getrolebySeasonid!)")
        if (UserDefaults.standard.bool(forKey: "3") == true)
                   {
                    docRef.collection("CannedResponse").order(by: "updated_datetime", descending: false).getDocuments() { (querySnapshot, err) in
                         if let err = err {
                             print("Error getting documents: \(err)")
                         } else {
                            self.TeamArray = NSMutableArray()

                             for document in querySnapshot!.documents {
                                 let data: NSDictionary = document.data() as NSDictionary
                                self.TeamArray.add(data)
                                
        
                            }
                            self.isTeam = true
                            self.createGroupView.isHidden = false
                            self.canned_response_tbl.reloadData()
                            Constant.showInActivityIndicatory()

                        }
                    }
        }
        else
        {
            docRef.collection("CannedResponse").order(by: "count", descending: true).getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                       self.TeamArray = NSMutableArray()

                                        for document in querySnapshot!.documents {
                                            let data: NSDictionary = document.data() as NSDictionary
                                           self.TeamArray.add(data)
                                           
                   
                                       }
                                       self.isTeam = true
                                       self.createGroupView.isHidden = false
                                       self.canned_response_tbl.reloadData()
                                       Constant.showInActivityIndicatory()

                                   }
                               }
        }
    }
    @IBAction func cancelbtn(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteMethod(rolebyDic: NSDictionary)
   {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
    let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(getrolebySeasonid!)")
        docRef.collection("CannedResponse").document("\(rolebyDic.value(forKey: "cannedResponseTitle")!)").delete()
        { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                let organizationId: NSDictionary = self.getRolebyreasonDetailArray?[0] as! NSDictionary
                let docrefs = db.collection("organization").document("\(self.getrolebySeasonid!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)")
                docrefs.collection("CannedResponse").document("\(rolebyDic.value(forKey: "cannedResponseTitle")!)").delete()
                { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        let addDoc = db.collection("organization").document("\(self.getrolebySeasonid!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                        addDoc.collection("CannedResponse").document("\(rolebyDic.value(forKey: "cannedResponseTitle")!)").delete()
                        { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                                Constant.showInActivityIndicatory()
                                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "CannedResponse Removed Successfully")
                                self.getCannedresponsegroup()
                            }
                        }

                    }

                }
                Constant.showInActivityIndicatory()


            }
        }
   }
    
    @IBAction func createcanresponse(_ sender: UIButton)
       {
          
           let vc = storyboard?.instantiateViewController(withIdentifier: "can_response_create") as! CannedResponseCreateVC
           vc.getorderArray = addorderArray
           vc.isCreate = true
           vc.delegate = self
        vc.rolebySeasonid = self.getrolebySeasonid
        vc.getrolebyorganizationArray = getSameOrganization
        vc.getTeamId = self.getTeamId

           self.navigationController?.pushViewController(vc, animated: true)
       }
    
    @IBAction func sortingCannedBtn_Action(_ sender: UIButton)
       {
           let vc = storyboard?.instantiateViewController(withIdentifier: "sorting") as! SortingVC
           vc.getorderArray = addorderArray
           vc.sortingOrderArray = self.TeamArray
           vc.selectType = "CannedResponse"
        vc.getorganizationDetails = getRolebyreasonDetailArray
        vc.rolebySeasonid = self.getrolebySeasonid as NSString?
        vc.getTeamId = self.getTeamId as NSString?
           self.navigationController?.pushViewController(vc, animated: true)
       }
}
