//
//  TagVC.swift
//  SportsGravy
//
//  Created by CSS on 16/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SWRevealViewController

class TagVC: UIViewController, UITableViewDelegate,UITableViewDataSource, SWRevealViewControllerDelegate, PassSelectorderDelegate {
    func createAfterCallMethod() {
        getTag()
    }
    
    func selectorderArray(select: NSMutableArray!, selectindex: UIButton) {
        self.addorderArray = select
        addTitle_btn.tag = selectindex.tag
        addTitle_btn.sendActions(for:  .touchUpInside)
    }
    

        @IBOutlet var addorderview: UIView!
        @IBOutlet weak var tag_tbl: UITableView!
        @IBOutlet weak var createGroupView: UIView!
        @IBOutlet weak var sorting: UIButton!



        var getRolebyreasonDetailArray: NSMutableArray!
        var getSameOrganization: NSMutableArray!
        var getdifferentOrganization: NSMutableArray!
        var getSameSportsArray: NSMutableArray!
        var getdifferentSportsArray: NSMutableArray!
        var getSameSeasonArray: NSMutableArray!
        var getdifferentSeasonArray: NSMutableArray!
        var addorderArray: NSMutableArray!
        var commonArray: [String]!
        
        
        var getSelectRole: String!
        var getOrganization: String!
        var getSport: String!
        var getSeason: String!
        var yPos = CGFloat()
        var addOrder: UIView!
        var getrolebySeasonid: String!
        var getTeamId: String!
        var TeamArray: NSMutableArray!
        var isTeam : Bool = false
        var addTitle_btn: UIButton!
    
    
       @IBOutlet weak var orderviewheight: NSLayoutConstraint!
        

        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.revealViewController()?.delegate = self
            tag_tbl.delegate = self
            tag_tbl.dataSource = self
            commonArray = NSMutableArray() as? [String]
            tag_tbl.tableFooterView = UIView()
            self.addorderArray = NSMutableArray()

            getorganization()
            getsportsmethod()
            getSeasonmethod()
            getTeammethod()
            getuserDetail()
            createGroupView.isHidden = true
            sorting.isHidden = true

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
                let btn_width =  70
                let frame1 = (i > 3) ? CGRect(x: 10, y: 55, width: btn_width, height: 40 ) : CGRect(x: 0 + (i * 70), y: 10, width: btn_width, height: 40 )
                //: (addorderArray.firstObject != nil) ? CGRect(x: 10 + (i * 75), y: 10, width: btn_width, height: 40 ) : CGRect(x: 0 + (i * 75), y: 10, width: btn_width, height: 40 )
                addTitle_btn = UIButton(frame: frame1)
                addTitle_btn.setTitle("\(addorderArray[i] as! String)", for: .normal)
                let lastIndex: Int = addorderArray.count-1
                
                if(lastIndex == i)
               {
                addTitle_btn.setTitleColor(UIColor.gray, for: .normal)
                addTitle_btn.isUserInteractionEnabled = false
                }
                else
               {
                addTitle_btn.setTitleColor(UIColor.blue, for: .normal)
                addTitle_btn.isUserInteractionEnabled = true

                }
                if(i==0)
                {
                addTitle_btn.titleLabel?.textAlignment = .right
                }
                else
                {
                 addTitle_btn.titleLabel?.textAlignment = .center

                }
                addTitle_btn.sizeToFit()
                addTitle_btn.tag = i
                self.addOrder.addSubview(addTitle_btn)
                addTitle_btn.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)

            }
           
            self.addorderview.addSubview(addOrder)
            if(commonArray.count > 0)
            {
                commonArray.removeAll { $0 == "" }
                tag_tbl.reloadData()

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
            
                        self.addorderArray.add(" > \(self.getSeason!)")
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
               return 50.0
            }
         }

                // create a cell for each table view row
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            if(isTeam == false)
            {
            let cell: UITableViewCell = self.tag_tbl.dequeueReusableCell(withIdentifier: "taguser")!
            cell.textLabel?.text = commonArray?[indexPath.row]
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
         
             return cell
             }
            else
            {
                let cell: TagCell = self.tag_tbl.dequeueReusableCell(withIdentifier: "tagcell") as! TagCell
                let dic: NSDictionary = TeamArray?[indexPath.row] as! NSDictionary
                let count : Int = dic.value(forKey: "count") as! Int
                cell.delete_enable_img.tag = indexPath.row
                cell.delete_enable_img.addTarget(self, action: #selector(deleteGroup_Method), for: .touchUpInside)
                cell.username_lbl?.text = dic.value(forKey: "tag_id") as? String
                cell.delete_enable_img.tintColor = (count > 0) ? UIColor.gray : UIColor.red
                cell.selectionStyle = .none
                cell.accessoryType = .none

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
                orderviewheight.constant = 90
                if (UserDefaults.standard.bool(forKey: "2") == true)
                {
                    sorting.isHidden = false

                }
                else
                {
                    sorting.isHidden = true

                }
                getTag()
            }
            }
        }
        @objc func deleteGroup_Method(_ sender: UIButton)
        {
            let indexno = sender.tag
            let teamDic: NSDictionary = self.TeamArray?[indexno] as! NSDictionary
            let count : Int = teamDic.value(forKey: "count") as! Int
            let isDelete: Bool = (count > 0) ? false : true
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
        func getTag()
        {
            Constant.internetconnection(vc: self)
                   Constant.showActivityIndicatory(uiView: self.view)
                   let getuuid = UserDefaults.standard.string(forKey: "UUID")
                    let db = Firestore.firestore()
            let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(getrolebySeasonid!)")
            if (UserDefaults.standard.bool(forKey: "2") == true)
            {
                docRef.collection("Tags").order(by: "updated_datetime", descending: false).getDocuments() { (querySnapshot, err) in
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
                                    self.tag_tbl.reloadData()
                                    Constant.showInActivityIndicatory()

                                }
                            }
            }
            else
            {
                docRef.collection("Tags").order(by: "count", descending: true).getDocuments() { (querySnapshot, err) in
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
                                    self.tag_tbl.reloadData()
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
          docRef.collection("Tags").document("\(rolebyDic.value(forKey: "tag_id")!)").delete()
          { err in
              if let err = err {
                  print("Error removing document: \(err)")
              } else {
                  print("Document successfully removed!")
                  let organizationId: NSDictionary = self.getRolebyreasonDetailArray?[0] as! NSDictionary
                  let docrefs = db.collection("organization").document("\(self.getrolebySeasonid!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)")
                  docrefs.collection("Tags").document("\(rolebyDic.value(forKey: "tag_id")!)").delete()
                  { err in
                      if let err = err {
                          print("Error removing document: \(err)")
                      } else {
                          print("Document successfully removed!")
                        let addDoc = db.collection("organization").document("\(organizationId.value(forKey: "organization_id")!)").collection("sports").document("\(organizationId.value(forKey: "sport_id")!)").collection("seasons").document("\(organizationId.value(forKey: "season_id")!)").collection("teams").document("\(self.getTeamId!)")
                          addDoc.collection("Tags").document("\(rolebyDic.value(forKey: "tag_id")!)").delete()
                          { err in
                              if let err = err {
                                  print("Error removing document: \(err)")
                              } else {
                                  print("Document successfully removed!")
                                  Constant.showInActivityIndicatory()
                                  Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "CannedResponse Removed Successfully")
                                  self.getTag()
                              }
                          }

                      }

                  }
                  Constant.showInActivityIndicatory()


              }
          }
     }
    
        @IBAction func cancelbtn(_ sender: UIButton)
        {
            self.navigationController?.popViewController(animated: true)
        }

    @IBAction func createTag(_ sender: UIButton)
    {
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "tag_create") as! TagCreateVC
        vc.getorderArray = addorderArray
        vc.delegate = self
        vc.rolebySeasonid = self.getrolebySeasonid
        vc.getrolebyorganizationArray = getSameOrganization
        vc.getTeamId = self.getTeamId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func sortingBtn_Action(_ sender: UIButton)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "sorting") as! SortingVC
        vc.getorderArray = addorderArray
        vc.sortingOrderArray = self.TeamArray
        vc.selectType = "Tags"
        vc.getorganizationDetails = self.getRolebyreasonDetailArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
