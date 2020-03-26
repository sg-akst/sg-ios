//
//  PostUsergroupVC.swift
//  SportsGravy
//
//  Created by CSS on 14/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import AVFoundation

protocol SelectuserGroubDelegate: AnyObject {
    func selectuserGroubDetail(userDetail: NSMutableArray)

}

class PostUsergroupVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PeopleSelectorDelegate {
    func selectPeopleSelectorDetail(userDetail: NSMutableArray) {
    self.delegate?.selectuserGroubDetail(userDetail: userDetail)
   // self.navigationController?.popViewController(animated: false)


    }
    
    func passorderArray(select: NSMutableArray!, selectindex: UIButton) {
         self.addorderArray = select
        addTitle_btn.tag = selectindex.tag
        addTitle_btn.sendActions(for:  .touchUpInside)
    }
    
    @IBOutlet weak var postusergroup_tbl: UITableView!
    var postGroupArray: NSMutableArray!
    var getSameOrganization: NSMutableArray!
    var getdifferentOrganization: NSMutableArray!
    var getRolebyreasonDetailArray: NSMutableArray!
    var getSameSportsArray: NSMutableArray!
    var getdifferentSportsArray: NSMutableArray!
    var getSameSeasonArray: NSMutableArray!
    var getSameLevelArray: NSMutableArray!
    var getdifferentLevelArray: NSMutableArray!
    var getSameTeamArray: NSMutableArray!
    var getdifferentTeamArray: NSMutableArray!
    var GroupList: NSMutableArray!

    weak var delegate:SelectuserGroubDelegate?

    var getdifferentSeasonArray: NSMutableArray!
    var getSeason: String!
    var getrolebySeasonid: String!
    var getSeasonid: String!

    var getTeamName: String!
    var getTeamId: String!
    //var getLevelid: String!
    var getLevel: String!
    var getLevelId: String!
    @IBOutlet var addorderview: UIView!
    @IBOutlet weak var orderviewheight: NSLayoutConstraint!
    var addOrder: UIView!

    var commonArray: [String]!
    var addorderArray: NSMutableArray!
    var addTitle_btn: UIButton!
    let getRole = UserDefaults.standard.string(forKey: "Role")
    var getOrganization: String!
    var getSport: String!

    override func viewDidLoad() {
        super.viewDidLoad()

       postGroupArray = NSMutableArray()
        addorderArray = NSMutableArray()
        commonArray = NSMutableArray() as? [String]
        
        postusergroup_tbl.tableFooterView = UIView()
        postusergroup_tbl.sizeToFit()
        self.postusergroup_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.postusergroup_tbl.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        getusergroup()
    }
    
    func getuserDetail()
        {

                    let buttons: NSMutableArray = NSMutableArray()
                    var indexOfLeftmostButtonOnCurrentLine: Int = 0
                    var runningWidth: CGFloat = 0.0
            let maxWidth: CGFloat = UIScreen.main.bounds.size.width
                    let horizontalSpaceBetweenButtons: CGFloat = 8.0
                    let verticalSpaceBetweenButtons: CGFloat = 0.0
                    if(self.addOrder != nil)
                    {
                       self.addOrder.removeFromSuperview()
                    }
                    self.addOrder = UIView()
                    self.addOrder.frame = self.addorderview.bounds
                    for i in 0..<self.addorderArray.count
                    {
                        addTitle_btn = UIButton(type: .roundedRect)
            
                        addTitle_btn.titleLabel?.font = UIFont(name: "Arial", size: 18)
                        addTitle_btn.titleLabel?.textAlignment = .left
                        let title: String = addorderArray?[i] as! String

                            if(title != "" && title != nil)
                                       {
                                       if(i == 0)
                                       {
                                           self.addTitle_btn.setTitle("\(addorderArray[i] as! String)", for: .normal)
                                       }
                                       else
                                       {
                                         addTitle_btn.setTitle(" >  \(addorderArray[i] as! String)", for: .normal)

                                       }
                        //addTitle_btn.setTitle("\(addorderArray[i] as! String)", for: .normal)
                        addTitle_btn.translatesAutoresizingMaskIntoConstraints = false
                        let attrStr = NSMutableAttributedString(string: "\(addTitle_btn.title(for: .normal) ?? "")")
                       
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
                                // vertical position:
                                let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .top, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .bottom, multiplier: 1.0, constant: verticalSpaceBetweenButtons + 5)
                                self.addOrder.addConstraint(verticalConstraint)
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
                                       // vertical position same as previous button
                            let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .top, relatedBy: .equal, toItem: previousButton, attribute: .top, multiplier: 1.0, constant: 0.0)
                            self.addOrder.addConstraint(verticalConstraint)

                        }
                        buttons.add(addTitle_btn)

                        }
                    }
                   
                    self.addorderview.addSubview(addOrder)
                  
                self.orderviewheight.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 70 : 40

                    
                    if(commonArray.count > 0)
                    {
                        commonArray.removeAll { $0 == "" }
                        postusergroup_tbl.reloadData()

                    }

                }
    
   func getorganization()
       {
           self.commonArray = NSMutableArray() as? [String]
           getSameOrganization = NSMutableArray()
           getdifferentOrganization = NSMutableArray()
           addorderArray.add("All")
           let filteredEvents: [String] = self.getRolebyreasonDetailArray.value(forKeyPath: "@distinctUnionOfObjects.organization_id") as! [String]
                      for i  in 0..<getRolebyreasonDetailArray.count
                      {
                      let roleDic: NSDictionary = getRolebyreasonDetailArray?[i] as! NSDictionary
          //
                      let abb: String = roleDic.value(forKey: "organization_id") as! String
                      if (filteredEvents.contains("\(abb)"))
                      {
                          print("found")
                          getOrganization = abb
                          getSameOrganization.add(roleDic)

                      }
                      else
                      {
                          print("not found")
                          getOrganization = abb

                          getdifferentOrganization.add(roleDic)
                      }
                          
                      }
        if(getdifferentOrganization.count > 1)
        {
                let filteredEvent =  self.getdifferentOrganization.value(forKeyPath: "@distinctUnionOfObjects.organization_abbrev") as! [String]

                self.commonArray.append(contentsOf: filteredEvent)

        }
        else
        {
                                           
            let filteredEvent = self.getSameOrganization.value(forKeyPath: "@distinctUnionOfObjects.organization_abbrev") as! [String]
            self.commonArray.append(contentsOf: filteredEvent)
                                            
        }
       }
       func getsportsmethod()
       {
           self.getSameSportsArray = NSMutableArray()
           self.getdifferentSportsArray = NSMutableArray()
           if(self.getdifferentOrganization.count > 1)
           {
                   self.commonArray = NSMutableArray() as? [String]

                     for i in 0..<getdifferentOrganization.count
                     {
                         let roleDic: NSDictionary = getdifferentOrganization?[i] as! NSDictionary
                         let role: String = roleDic.value(forKey: "organization_id") as! String
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
    if(getdifferentSportsArray.count > 1)
               {
                   let filteredEvent: [String] = self.getdifferentSportsArray.value(forKeyPath: "@distinctUnionOfObjects.sport_name") as! [String]
                   self.commonArray.append(contentsOf: filteredEvent)

               }
              else
             {
                    let filteredEvent: [String] = self.getSameSportsArray.value(forKeyPath: "@distinctUnionOfObjects.sport_name") as! [String]
                   self.commonArray.append(contentsOf: filteredEvent)

               }
            
                 }
           else if(self.getSameOrganization.count > 0)
           {
               self.commonArray = NSMutableArray() as? [String]
               for i in 0..<getSameOrganization.count
               {
                   let roleDic: NSDictionary = getSameOrganization?[i] as! NSDictionary
                   let role: String = roleDic.value(forKey: "organization_id") as! String
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
            var filteredEvents: [String] = self.getSameOrganization.value(forKeyPath: "@distinctUnionOfObjects.sport_name") as! [String]
            filteredEvents.sort()
               self.commonArray.append(contentsOf: filteredEvents)
           }
       }
       func getSeasonmethod()
       {
            self.getSameSeasonArray = NSMutableArray()
                      self.getdifferentSeasonArray = NSMutableArray()
                      if(self.getdifferentSportsArray.count > 1)
                             {

                                 self.commonArray = NSMutableArray() as? [String]
                                 for i in 0..<getdifferentSportsArray.count
                                 {
                                     let roleDic: NSDictionary = getdifferentSportsArray?[i] as! NSDictionary
                                     let role: String = roleDic.value(forKey: "sport_id") as! String
                                     if(role == getSport)
                                     {
                                         self.getSeason = roleDic.value(forKey: "season_label") as? String
                                         getSameSeasonArray.add(roleDic)
                                        getrolebySeasonid = roleDic.value(forKey: "role_by_season_id") as? String
                                      getSeasonid = roleDic.value(forKey: "season_id") as? String

                                     }
                                     else
                                     {
                                         getdifferentSeasonArray.add(roleDic)
                                     }
                                
                                 }
                                
                                if(getdifferentSeasonArray.count > 1)
                                  {
                                      let filteredEvent: [String] = self.getdifferentSeasonArray.value(forKeyPath: "@distinctUnionOfObjects.season_label") as! [String]
                                      self.commonArray.append(contentsOf: filteredEvent)

                                  }
                                 else
                                {
                                       let filteredEvent: [String] = self.getSameSeasonArray.value(forKeyPath: "@distinctUnionOfObjects.season_label") as! [String]
                                      self.commonArray.append(contentsOf: filteredEvent)

                                  }
            }
                      else if (self.getSameSportsArray.count > 0)
                      {
                          self.commonArray = NSMutableArray() as? [String]
                          for i in 0..<getSameSportsArray.count
                          {
                              let roleDic: NSDictionary = getSameSportsArray?[i] as! NSDictionary
                              let role: String = roleDic.value(forKey: "sport_id") as! String
                              if(role == getSport)
                              {
                                  self.getSeason = roleDic.value(forKey: "season_label") as? String
                                  getSameSeasonArray.add(roleDic)
                                  getrolebySeasonid = roleDic.value(forKey: "role_by_season_id") as? String
                                  getSeasonid = roleDic.value(forKey: "season_id") as? String
                              }
                              else
                              {
                                 getdifferentSeasonArray.add(roleDic)
                               }
                             
                          }
                        var filteredEvents: [String] = self.getSameSportsArray.value(forKeyPath: "@distinctUnionOfObjects.season_label") as! [String]
                        filteredEvents.sort()
                        self.commonArray.append(contentsOf: filteredEvents)
                      }
       }
      func getLevelmethod()
       {
           self.getSameLevelArray = NSMutableArray()
           self.getdifferentLevelArray = NSMutableArray()
           if(getdifferentSeasonArray.count>1)
           {
               self.commonArray = NSMutableArray() as? [String]
               for i in 0..<getdifferentSeasonArray.count
               {
                   let roleDic: NSDictionary = getdifferentSeasonArray?[i] as! NSDictionary
                   let role: String = roleDic.value(forKey: "season_id") as! String
                   if(role == getSeasonid)
                   {
                       self.getLevel = roleDic.value(forKey: "level_name") as? String
                       getSameLevelArray.add(roleDic)
                       getLevelId = roleDic.value(forKey: "level_id") as? String
                   }
                   else
                   {
                       getdifferentLevelArray.add(roleDic)
                   }
                   
               }
            if(getdifferentLevelArray.count > 1)
              {
                  let filteredEvent: [String] = self.getdifferentLevelArray.value(forKeyPath: "@distinctUnionOfObjects.level_name") as! [String]
                  self.commonArray.append(contentsOf: filteredEvent)

              }
             else
            {
                   let filteredEvent: [String] = self.getSameLevelArray.value(forKeyPath: "@distinctUnionOfObjects.level_name") as! [String]
                  self.commonArray.append(contentsOf: filteredEvent)

              }
            
           }
           else if(getSameSeasonArray.count>0)
           {
               self.commonArray = NSMutableArray() as? [String]
                   for i in 0..<getSameSeasonArray.count
                   {
                       let roleDic: NSDictionary = getSameSeasonArray?[i] as! NSDictionary
                       let role: String = roleDic.value(forKey: "season_id") as! String
                       if(role == getSeasonid)
                       {
                           self.getLevel = roleDic.value(forKey: "level_name") as? String
                           getSameLevelArray.add(roleDic)
                           getLevelId = roleDic.value(forKey: "level_id") as? String

                        }
                       else
                       {
                           getdifferentLevelArray.add(roleDic)
                        }
                      
                   }
            var filteredEvents: [String] = self.getSameSeasonArray.value(forKeyPath: "@distinctUnionOfObjects.level_name") as! [String]
            filteredEvents.sort()
            self.commonArray.append(contentsOf: filteredEvents)
           }
       }
       func getTeammethod()
       {
        self.getSameTeamArray = NSMutableArray()
                   self.getdifferentTeamArray = NSMutableArray()
                   
                       if(self.getdifferentLevelArray.count > 1)
                               {
                                   self.commonArray = NSMutableArray() as? [String]

                                   for i in 0..<getdifferentLevelArray.count
                                   {
                                       let roleDic: NSDictionary = getSameSeasonArray?[i] as! NSDictionary
                                       let role: String = roleDic.value(forKey: "level_id") as! String
                                       if(role == getLevelId)
                                       {
                                        self.getTeamName = roleDic.value(forKey: "team_name") as? String
                                         getSameTeamArray.add(roleDic)
                                         getTeamId = roleDic.value(forKey: "team_id") as? String

                                           }
                                           else
                                           {
                                              getdifferentTeamArray.add(roleDic)
                                           }
                                   }

                                   var filteredEvents: [String] = self.getdifferentLevelArray.value(forKeyPath: "@distinctUnionOfObjects.team_name") as! [String]
                                filteredEvents.sort()
                                   self.commonArray.append(contentsOf: filteredEvents)


                               }
                       else if(getSameLevelArray.count > 0)
                        {
                           self.commonArray = NSMutableArray() as? [String]
                           for i in 0..<getSameLevelArray.count
                           {
                             let roleDic: NSDictionary = getSameLevelArray?[i] as! NSDictionary
                             let role: String = roleDic.value(forKey: "level_id") as! String
                             if(role == getSeasonid)
                               {
                                   self.getTeamName = roleDic.value(forKey: "team_name") as? String
                                   getSameTeamArray.add(roleDic)
                                   getTeamId = roleDic.value(forKey: "team_id") as? String

                               }
                               else
                               {
                                   getdifferentTeamArray.add(roleDic)
                               }
                           }
                           var filteredEvents: [String] = self.getSameLevelArray.value(forKeyPath: "@distinctUnionOfObjects.team_name") as! [String]
                            filteredEvents.sort()
                           self.commonArray.append(contentsOf: filteredEvents)
                       }
    }
    func usergroup()
    {
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(self.getrolebySeasonid!)")
        docRef.collection("MemberGroup").order(by: "updated_datetime", descending: false).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    } else {
                        self.GroupList = NSMutableArray()
                        for document in querySnapshot!.documents {
                        let data: NSDictionary = document.data() as NSDictionary
                        self.GroupList.add(data)
                        }
                        self.commonArray = NSMutableArray() as? [String]
                        var filteredEvents: [String] = self.GroupList.value(forKeyPath: "@distinctUnionOfObjects.display_name") as! [String]
                    filteredEvents.sort()
                        self.commonArray.append(contentsOf: filteredEvents)
                        self.getuserDetail()
                }
                Constant.showInActivityIndicatory()
           }
        }
       
    @objc func orderselectmethod(_ sender: UIButton)
       {
           let selecttag = sender.tag
          // orderviewheight.constant = 50
           if(selecttag == 0)
           {
               print("All")
               getorganization()
            for i in 0..<addorderArray.count
            {
                if(i>0)
                {
                  self.addorderArray.removeLastObject()
                }
            }
               getuserDetail()
           }
           else if(selecttag == 1)
           {
               print("organization")
               getorganization()
               getsportsmethod()
            for i in 0..<addorderArray.count
            {
                if(i>1)
                {
                  self.addorderArray.removeLastObject()
                }
            }
               getuserDetail()
           }
           else if(selecttag == 2)
           {
               print("Sport")
              
               getorganization()
               getsportsmethod()
               getSeasonmethod()
            for i in 0..<addorderArray.count
            {
                if(i>2)
                {
                  self.addorderArray.removeLastObject()
                }
            }
               getuserDetail()
           }
           else if(selecttag == 3)
           {
            print("season")
            getorganization()
            getsportsmethod()
            getSeasonmethod()
            getLevelmethod()
            for i in 0..<addorderArray.count
            {
                if(i>3)
                {
                  self.addorderArray.removeLastObject()
                }
            }
            getuserDetail()
           }
           else if(selecttag == 4)
           {
             getorganization()
             getsportsmethod()
             getSeasonmethod()
             getLevelmethod()
             getTeammethod()
            for i in 0..<addorderArray.count
            {
                if(i>4)
                {
                  self.addorderArray.removeLastObject()
                }
            }
             getuserDetail()
           }
        else if(selecttag == 5)
           {
                getorganization()
                getsportsmethod()
                getSeasonmethod()
                getLevelmethod()
                getTeammethod()
          //  self.addorderArray.add("\(getTeamId!)")
                usergroup()
            for i in 0..<addorderArray.count
            {
                if(i>5)
                {
                  self.addorderArray.removeLastObject()
                }
            }
                getuserDetail()
           }
        else
           {
            print("Player")
        }
       }
       
    func numberOfSections(in tableView: UITableView) -> Int {
                 return 1
             }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                 return self.commonArray.count
             }
             public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                 return 50.0
             }
             
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell: PostUserCell = tableView.dequeueReusableCell(withIdentifier: "custompostusercell", for: indexPath) as! PostUserCell
        cell.groub_img.setTitleColor(UIColor.black, for: .normal)
        cell.groub_img.setTitle(self.commonArray[indexPath.row], for: .normal)
       let name = self.commonArray[indexPath.row]
        let size = (name as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
        print("size\(size)")
                   if((getRole == "coach" || getRole == "manager"))
                  {
                    if(self.addorderArray.count == 5)
                    {
                        cell.imageBtn.frame = CGRect(x: size.width + 25, y: 5, width: 25, height: 25)
                        cell.imageBtn.addTarget(self, action: #selector(PersonIcon), for: .touchUpInside)
                        cell.imageBtn.isHidden  = false
                        cell.imageBtn.setImage(UIImage(named: "user"), for: .normal)
                        cell.imageBtn.tintColor = UIColor.black
                    }
                    else
                    {
                        cell.imageBtn.setImage(nil, for: .normal)
                        cell.imageBtn.isHidden  = true
                   }
                   }
                  else
                  {
                    cell.imageBtn.setImage(UIImage(named: "user"), for: .normal)
                    cell.imageBtn.tintColor = UIColor.black

                    cell.imageBtn.isHidden  = false
                   }
                   cell.imageBtn.tag = indexPath.row

                    cell.groub_img.tag = indexPath.row
                    cell.groub_img.setTitleColor(UIColor.blue, for: .normal)
                    cell.groub_img.addTarget(self, action: #selector(SelectTeamName), for: .touchUpInside)
                    cell.selectionStyle = .none
                    cell.accessoryType = (addorderArray.count == 7) ? .none : .disclosureIndicator
                return cell
                }
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              print("You tapped cell number \(indexPath.row).")
    if(self.addorderArray.count < 5)
    {
    //self.addorderArray = NSMutableArray()
        if(addorderArray.count == 1)
        {
            
            for i in 0..<self.getRolebyreasonDetailArray.count
            {
                 let roleDic: NSDictionary = getRolebyreasonDetailArray?[i] as! NSDictionary
                 let role: String = roleDic.value(forKey: "organization_abbrev") as! String
                if(self.commonArray[indexPath.row] == role)
                {
                    getOrganization = roleDic.value(forKey: "organization_id") as? String

                }
            }
            self.addorderArray.add(commonArray[indexPath.row])
           
            getsportsmethod()
        }
        else if(addorderArray.count == 2)
        {
            for i in 0..<self.getRolebyreasonDetailArray.count
            {
                 let roleDic: NSDictionary = getRolebyreasonDetailArray?[i] as! NSDictionary
                 let role: String = roleDic.value(forKey: "sport_name") as! String
                if(self.commonArray[indexPath.row] == role && roleDic.value(forKey: "organization_id") as? String == getOrganization)
                {
                    getSport = roleDic.value(forKey: "sport_id") as? String

                }
            }
            self.addorderArray.add(commonArray[indexPath.row])
            getSeasonmethod()

        }
        else if(addorderArray.count == 3)
        {
            for i in 0..<self.getRolebyreasonDetailArray.count
            {
                 let roleDic: NSDictionary = getRolebyreasonDetailArray?[i] as! NSDictionary
                 let role: String = roleDic.value(forKey: "sport_name") as! String
                if(self.commonArray[indexPath.row] == role && roleDic.value(forKey: "sport_id") as? String == getSport)
                {
                    getLevelId = roleDic.value(forKey: "level_id") as? String

                }
            }
            self.addorderArray.add(commonArray[indexPath.row])
             getLevelmethod()

        }
        else if(addorderArray.count == 4)
        {
            for i in 0..<self.getRolebyreasonDetailArray.count
            {
                 let roleDic: NSDictionary = getRolebyreasonDetailArray?[i] as! NSDictionary
                 let role: String = roleDic.value(forKey: "level_name") as! String
                if(self.commonArray[indexPath.row] == role && roleDic.value(forKey: "level_id") as? String == getSport)
                {
                    getTeamId = roleDic.value(forKey: "team_id") as? String

                }
            }
            self.addorderArray.add(commonArray[indexPath.row])
             getTeammethod()

        }
   // getorganization()
    //getsportsmethod()
   // getSeasonmethod()
    //getLevelmethod()
    //getTeammethod()
    getuserDetail()

    }
    else if(self.addorderArray.count == 5)
    {
        self.addorderArray.add("\(self.commonArray[indexPath.row])")
        self.getTeamId = self.commonArray[indexPath.row]
        usergroup()
    }
    else if(self.addorderArray.count  == 6)
    {
       self.addorderArray.add("\(self.commonArray[indexPath.row])")
        let selectGroup:NSDictionary =  GroupList?[indexPath.row] as! NSDictionary
        let slectplayer: NSArray = selectGroup.value(forKey: "user_list") as! NSArray
        self.commonArray = NSMutableArray() as? [String]
        for i in 0..<slectplayer.count
        {
            let roleDic: NSDictionary = slectplayer[i] as! NSDictionary
            let role: String = "\(roleDic.value(forKey: "first_name") as! String)" + "\(roleDic.value(forKey: "last_name")!)"
            let filteredEvents: [String] = [role]
            //filteredEvents.sort()
            self.commonArray.append(contentsOf: filteredEvents)

        }
        getuserDetail()

    }
   else
    {
        
    }
}
    @objc func PersonIcon(_ sender: UIButton)
    {
        let selectpeople = sender.tag
        var peopleArray: NSMutableArray = NSMutableArray()
        if((getRole == "coach" || getRole == "manager"))
        {
           peopleArray = ["Coaches", "Guardians", "Players", "Managers"]
        }
        else
        {
           peopleArray = ["Administrators", "Coaches", "Evaluators", "Guardians", "Players", "Managers"]
        }
         let vc = storyboard?.instantiateViewController(withIdentifier: "peopleselector") as! PeopleSelectorVC
        vc.delegate = self
        self.addorderArray.add("\(self.commonArray[sender.tag])")
         vc.orderArray = addorderArray
         vc.peoplegrouplist = peopleArray
        vc.auth_UID  = UserDefaults.standard.string(forKey: "UUID")
        vc.role = UserDefaults.standard.string(forKey: "Role")
        vc.organization_id = getOrganization
        vc.sport_id = getSport
        vc.season_id = getSeasonid
        vc.level_id = getLevelId
       
        if(self.getdifferentLevelArray.count > 1)
        {
            let selectDic: NSDictionary = self.getdifferentLevelArray?[selectpeople] as! NSDictionary
            vc.team_id = selectDic.value(forKey: "team_id") as? String
            vc.getpeopleselectorArray = self.getdifferentLevelArray
        }
        else
        {
            let selectDic: NSDictionary = self.getSameLevelArray?[selectpeople] as! NSDictionary
            vc.team_id = selectDic.value(forKey: "team_id") as? String
            vc.getpeopleselectorArray = self.getSameLevelArray
        }
        self.navigationController?.pushViewController(vc, animated: true)

    }
                     
    func getusergroup()
    {
                Constant.internetconnection(vc: self)
               Constant.showActivityIndicatory(uiView: self.view)
               let getuuid = UserDefaults.standard.string(forKey: "UUID")
                let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)")
        
        docRef.collection("roles_by_season").whereField("role", isEqualTo: getRole!).getDocuments() { (querySnapshot, err) in
            Constant.showInActivityIndicatory()

               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                self.getRolebyreasonDetailArray = NSMutableArray()

                       for document in querySnapshot!.documents {
                       let data: NSDictionary = document.data() as NSDictionary
                        let getseason_end_date =  data.value(forKey: "season_end_date") as? Timestamp
                        let getSeason_start_date = data.value(forKey: "season_start_date") as? Timestamp
                        print("\(document.documentID) => \(String(describing: getseason_end_date))")
                        if(data.value(forKey: "team_id") as? String != nil && data.value(forKey: "team_id")as! String != "")
                        {
                            if(getSeason_start_date != nil && getseason_end_date != nil)
                            {
                                let enddate = Date(timeIntervalSince1970: TimeInterval(getseason_end_date!.seconds))
                                let startDate = Date(timeIntervalSince1970:TimeInterval(getSeason_start_date!.seconds))
                                let currentDate = Date()  as Date?
                                if(enddate > currentDate! || startDate < currentDate!)
                                {
                                        print("yes")
                                    self.getRolebyreasonDetailArray.add(data)
                                }
                            }
                        }
                        
                      }
                
                if(self.getRolebyreasonDetailArray.count > 0)
                {
                    self.getorganization()
                    //self.getsportsmethod()
                   // self.getSeasonmethod()
                   // self.getLevelmethod()
                   // self.getTeammethod()
                    self.getuserDetail()


                }
                   Constant.showInActivityIndicatory()

                       }
                   }

    }
  
    
    @objc func SelectTeamName(_ sender: UIButton)
    {
        let button = sender.tag
        let getTeam: String = self.commonArray[button]
        print(getTeam)
        let selectTeamDetail: NSMutableArray = NSMutableArray()
        if(self.addorderArray.count == 5)
        {
        for i in 0..<self.getSameLevelArray.count
        {
            let dic: NSDictionary = self.getSameLevelArray?[i] as! NSDictionary
            if(getTeam == dic.value(forKey: "team_name") as? String)
            {
                print(dic)
                let addgroup: NSMutableDictionary = getSameLevelArray?[0] as! NSMutableDictionary
                addgroup.setValue("", forKey: "membergroup_id")
                addgroup.setValue("", forKey: "membergroup_name")
                addgroup.setValue("", forKey: "user_id")
                addgroup.setValue("", forKey: "user_name")
                selectTeamDetail.add(addgroup)
            }
        }
            
        }
        else if(self.addorderArray.count == 6)
        {
            if(self.GroupList.count>0)
            {
            for i in 0..<self.GroupList.count
            {
                let dic: NSDictionary = GroupList?[i] as! NSDictionary
                if(getTeam == dic.value(forKey: "display_name") as? String)
                {
                    print(dic)
                    
                    let addgroup: NSMutableDictionary = getSameLevelArray?[0] as! NSMutableDictionary
                    addgroup.setValue(dic.value(forKey: "user_groupId"), forKey: "membergroup_id")
                    addgroup.setValue(dic.value(forKey: "user_groupId"), forKey: "membergroup_name")
                    addgroup.setValue("", forKey: "user_id")
                    addgroup.setValue("", forKey: "user_name")
                    selectTeamDetail.add(addgroup)
                }
            }
            }
        }
        else if(self.addorderArray.count > 6)
        {
            for i in 0..<self.GroupList.count
            {
                let dic: NSDictionary = GroupList?[i] as! NSDictionary
                let slectplayer: NSArray = dic.value(forKey: "user_list") as! NSArray
                for i in 0..<slectplayer.count
                {
                    let roleDic: NSDictionary = slectplayer[i] as! NSDictionary
                    let role: String = "\(roleDic.value(forKey: "first_name") as! String)" + "\(roleDic.value(forKey: "last_name")!)"
                    if(role == getTeam)
                    {
                        let addgroup: NSMutableDictionary = getSameLevelArray?[0] as! NSMutableDictionary
                        addgroup.setValue(dic.value(forKey: "user_groupId"), forKey: "membergroup_id")
                        addgroup.setValue(dic.value(forKey: "user_groupId"), forKey: "membergroup_name")
                        addgroup.setValue(role, forKey: "user_id")
                        addgroup.setValue(role, forKey: "user_name")
                        
                        selectTeamDetail.add(addgroup)
                    }

                }
                
                
                if(getTeam == dic.value(forKey: "display_name") as? String)
                {
                    print(dic)
                               
                    let addgroup: NSMutableDictionary = getSameLevelArray?[0] as! NSMutableDictionary
                    addgroup.setValue(dic.value(forKey: "user_groupId"), forKey: "user_groupId")
                    selectTeamDetail.add(addgroup)
                }
                }
        }
        
        if(selectTeamDetail.count > 0)
        {
         self.delegate?.selectuserGroubDetail(userDetail: selectTeamDetail)
        }
        else
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Coach can select Team or above as usergroup")
        }

        self.navigationController?.popViewController(animated: true)


    }
    
       @IBAction func backpostuserbtn(_ sender: UIButton)
          {
              self.navigationController?.popViewController(animated: true)
          }
}
