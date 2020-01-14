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

class UsergroupVC: UIViewController, SWRevealViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var addorderview: UIView!
    @IBOutlet weak var usergroup_tbl: UITableView!

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
    var TeamArray: NSMutableArray!
    var isTeam : Bool = false
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
            let button = UIButton(frame: frame1)
            button.setTitle("\(addorderArray[i] as! String)", for: .normal)
            let lastIndex: Int = addorderArray.count-1
            
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
            self.addOrder.addSubview(button)
            button.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)

        }
       
        self.addorderview.addSubview(addOrder)
        if(commonArray.count > 0)
        {
            commonArray.removeAll { $0 == "" }
            usergroup_tbl.reloadData()

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
            //self.addorderArray = NSMutableArray()

            self.addorderArray.removeLastObject()
//             commonArray.append(self.getSeason)
            getuserDetail()
            //self.commonArray.append(getSeason)

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
           return 80.0
        }
     }

            // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(isTeam == false)
        {
        let cell: UITableViewCell = self.usergroup_tbl.dequeueReusableCell(withIdentifier: "user")!
        cell.textLabel?.text = commonArray?[indexPath.row]
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
            let filteredEvents: [String] = userArray.value(forKeyPath: "@distinctUnionOfObjects.first_name") as! [String]
            //let appendStr: String!
//            for i in 0..<userArray.count
//            {
//                let dic: NSDictionary = userArray[i] as! NSDictionary
//                appendStr.append("\(dic.value(forKey: "first_name")!)" + "\(dic.value(forKey: "last_name")!)")
//                //filteredEvents.append("\(dic.value(forKey: "first_name")!)" + "\(dic.value(forKey: "last_name")!)")
//                //filteredEvents.append(username)
//
//
//            }
            cell.displayName_lbl?.text = dic.value(forKey: "display_name") as? String
            cell.delete_enable_img.tintColor = (count > 0) ? UIColor.gray : UIColor.red
            cell.username_lbl?.text = "\(String(describing: filteredEvents))"
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            
                return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
           print("You tapped cell number \(indexPath.row).")
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

                }
            }
//
            orderviewheight.constant = 90
            getmembergroup()
        }
    }
    func getmembergroup()
    {
        Constant.internetconnection(vc: self)
               Constant.showActivityIndicatory(uiView: self.view)
               let getuuid = UserDefaults.standard.string(forKey: "UUID")
                let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(getrolebySeasonid!)")
        
        docRef.collection("MemberGroup").getDocuments() { (querySnapshot, err) in
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
                            self.usergroup_tbl.reloadData()
                            Constant.showInActivityIndicatory()

                        }
                    }
        
    }
    @IBAction func cancelbtn(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
//        self.revealViewController()?.dismiss(animated: true, completion: nil)
    }

}
