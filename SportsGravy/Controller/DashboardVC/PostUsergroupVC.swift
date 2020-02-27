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

protocol SelectuserGroubDelegate: AnyObject {
    func selectuserGroubDetail(userDetail: NSMutableArray)

}



class PostUsergroupVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
    weak var delegate:SelectuserGroubDelegate?

    var getdifferentSeasonArray: NSMutableArray!
    var getSeason: String!
    var getrolebySeasonid: String!
    var getTeamId: String!
    var getLevelid: String!
    var getLevel: String!






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

        getusergroup()
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
                        postusergroup_tbl.reloadData()
        //                let indexPath = IndexPath(row: 0, section: 0)
        //                self.usergroup_tbl.scrollToRow(at: indexPath, at: .top, animated: false)

                    }

                }
    
    func getorganization(){
        self.commonArray = NSMutableArray() as? [String]
        getSameOrganization = NSMutableArray()
        getdifferentOrganization = NSMutableArray()
        addorderArray.add("All")
        for i in 0..<self.postGroupArray.count
        {
             let roleDic: NSDictionary = postGroupArray?[i] as! NSDictionary
             let role: String = roleDic.value(forKey: "role") as! String
            if(role == getRole)
            {
                getOrganization = roleDic.value(forKey: "organization_abbrev") as? String
                self.getSameOrganization.add(roleDic)
                
            }
            else
             {
                getdifferentOrganization.add(roleDic)
            }
        }
        let filteredEvents: [String] = self.postGroupArray.value(forKeyPath: "@distinctUnionOfObjects.organization_abbrev") as! [String]
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
           if(self.getdifferentSportsArray.count < 1 )
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
    
    func getLevelMethod()
    {
         if(self.getdifferentSeasonArray.count < 1 )
                         {
                             self.commonArray = NSMutableArray() as? [String]
                             self.addorderArray.add("> \(getSeason!)")
                             self.getSameLevelArray = NSMutableArray()
                             self.getdifferentLevelArray = NSMutableArray()
                             for i in 0..<getSameSeasonArray.count
                             {
                                 let roleDic: NSDictionary = getSameSeasonArray?[i] as! NSDictionary
                                 let role: String = roleDic.value(forKey: "role_by_season_id") as! String
                                 if(role == getrolebySeasonid)
                                 {
                                     self.getLevel = roleDic.value(forKey: "level_name") as? String
                                     getSameLevelArray.add(roleDic)
                                  getLevelid = roleDic.value(forKey: "level_id") as? String
                                  //"@distinctUnionOfObjects.role_by_season_id") as! String)

                                 }
                                 else
                                 {
                                     getdifferentLevelArray.add(roleDic)
                                 }
                             }
                         }
    }
    
       func getTeammethod()
       {
            if(getSameLevelArray.count > 0)
                   {

                    self.commonArray = NSMutableArray() as? [String]
                    //self.commonArray = getSameSeasonArray as? [String]
//                       self.addorderArray.add("> \(getSeason!)")
                       let filteredEvents: [String] = self.getSameLevelArray.value(forKeyPath: "@distinctUnionOfObjects.team_name") as! [String]
                     
                       self.commonArray.append(contentsOf: filteredEvents)
                       

                   }
        //postusergroup_tbl.reloadData()
       }
       
    @objc func orderselectmethod(_ sender: UIButton)
       {
           let selecttag = sender.tag
           orderviewheight.constant = 50

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
               getuserDetail()
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
                
                if(self.addorderArray.count < 5)
                {
                let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "postusercell", for: indexPath)
                cell.textLabel?.text = commonArray?[indexPath.row]
                cell.textLabel?.textColor = UIColor.blue
                cell.selectionStyle = .none
                cell.accessoryType = .disclosureIndicator
                return cell
                }
                else{
                    let cell: PostUserCell = tableView.dequeueReusableCell(withIdentifier: "custompostusercell", for: indexPath) as! PostUserCell
                    cell.groub_img.setTitle(commonArray[indexPath.row], for: .normal)
                    cell.groub_img.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(cell.groub_img.imageView?.frame.size.width)!, bottom: 0, right: (cell.groub_img.imageView?.frame.size.width)!)
                   
                    cell.groub_img.imageEdgeInsets = UIEdgeInsets(top: 0, left: (cell.groub_img.titleLabel?.frame.size.width)!, bottom: 0, right: -(cell.groub_img.titleLabel?.frame.size.width)!)
                    cell.groub_img.imageView?.image = UIImage(named: "user")
                    cell.groub_img.tag = indexPath.row
                    cell.groub_img.addTarget(self, action: #selector(SelectTeamName), for: .touchUpInside)
                    cell.groub_img.setTitleColor(UIColor.blue, for: .normal)
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
                      getLevelMethod()
                      getTeammethod()
                      getuserDetail()

                      }

                      else
                      {
                         print(getSeason)
                       if(postGroupArray.count > 0)
                        {
                            let str: String = addorderArray?.lastObject as! String
                            let str1 = str.dropFirst(2)
                            self.addorderArray.add("> \(getLevel!)")

                            if( str1 == self.getLevel)
                            {
                                self.addorderArray.removeLastObject()
                            }
                           
                            self.commonArray = NSMutableArray() as? [String]
                       
                             let filteredEvents: [String] = self.postGroupArray.value(forKeyPath: "@distinctUnionOfObjects.team_name") as! [String]
                                             
                             self.commonArray.append(contentsOf: filteredEvents)
                            }
                         
                        orderviewheight.constant = 90
                        getuserDetail()

                }
                      }
                     
    func getusergroup()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)")
        docRef.collection("roles_by_season").whereField("role", isEqualTo: getRole!).getDocuments() { (querySnapshot, err) in
                                 if let err = err {
                                     print("Error getting documents: \(err)")
                                 } else {
                                    self.postGroupArray = NSMutableArray()

                                     for document in querySnapshot!.documents {
                                         let data: NSDictionary = document.data() as NSDictionary
                                        let getseason_end_date: Timestamp =  (data.value(forKey: "season_end_date") as? Timestamp)!
                                        let getSeason_start_date: Timestamp = (data.value(forKey: "season_start_date") as? Timestamp)!
                                         print("\(document.documentID) => \(getseason_end_date)")
                                        let enddate: Date = getseason_end_date.dateValue()
                                        let startDate: Date  = getSeason_start_date.dateValue()
                                       if(enddate > Date() || startDate < Date())
                                        {
                                            print("yes")
                                            self.postGroupArray.add(data)
                                        }
                                       
                                    }
                                    if(self.postGroupArray.count>0)
                                    {
                                       // let getuserinfo: NSDictionary = self.postGroupArray?[0] as! NSDictionary
                                        //UserDefaults.standard.set(getuserinfo, forKey: "UserInformation")
                                       // UserDefaults.standard.set(getuserinfo, forKey: "UserInformation")
                                        self.getorganization()
                                        self.getsportsmethod()
                                        self.getSeasonmethod()
                                        self.getLevelMethod()
                                        self.getTeammethod()
                                        self.getuserDetail()
                                        

                                    }
                                    self.postusergroup_tbl.reloadData()
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
        for i in 0..<getSameSeasonArray.count
        {
            let dic: NSDictionary = getSameSeasonArray?[i] as! NSDictionary
            if(getTeam == dic.value(forKey: "team_name") as? String)
            {
                print(dic)
                selectTeamDetail.add(dic)
            }
        }
        self.navigationController?.popViewController(animated: true)

        self.delegate?.selectuserGroubDetail(userDetail: selectTeamDetail)

    }
    
       @IBAction func backpostuserbtn(_ sender: UIButton)
          {
              self.navigationController?.popViewController(animated: true)
          }
}
