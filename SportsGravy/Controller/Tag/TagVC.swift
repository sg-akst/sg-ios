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

class TagVC: UIViewController, UITableViewDelegate,UITableViewDataSource, SWRevealViewControllerDelegate, PassSelectorderDelegate, SortorderDelegate {
    func sortingOrderTagupdateSuccess() {
       // getTag()
        getTagListMethod()
    }
    
    func sortingOrderUsergroupupdateSuccess() {
        
    }
    
    func sortingOrderCannedupdateSuccess() {
        
    }
    
    func createAfterCallMethod() {
        //getTag()
        getTagListMethod()

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
        var getSameLevelArray: NSMutableArray!
        var getdifferentLevelArray: NSMutableArray!
    
        var addorderArray: NSMutableArray!
        var commonArray: [String]!
        var getSelectRole: String!
        var getOrganization: String!
        var getSport: String!
        var getSeason: String!
       var getLevel: String!

        var yPos = CGFloat()
        var addOrder: UIView!
        var getrolebySeasonid: String!
    var getLevelId: String!

        var getTeamId: String!
        var TeamArray: NSMutableArray!
        var isTeam : Bool = false
        var addTitle_btn: UIButton!
    
    @IBOutlet weak var orderviewheight: NSLayoutConstraint!
    var stackView : UIStackView?
       var outerStackView : UIStackView?
       var label1 = UILabel()
       var label2 = UILabel()
       var heightAnchor : NSLayoutConstraint?
       var widthAnchor : NSLayoutConstraint?
    
override func viewDidLoad() {
            super.viewDidLoad()
            self.revealViewController()?.delegate = self
            tag_tbl.delegate = self
            tag_tbl.dataSource = self
            commonArray = NSMutableArray() as? [String]
            tag_tbl.tableFooterView = UIView()
            self.addorderArray = NSMutableArray()
             getTag()
            createGroupView.isHidden = true
            sorting.isHidden = true
            self.tag_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.tag_tbl.contentInset = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)

            self.tag_tbl.sizeToFit()
        }
        func getuserDetail()
        {
           // self.orderviewheight.constant = (self.addorderArray.count > 4) ? 90 : 50

            let buttons: NSMutableArray = NSMutableArray()
            var indexOfLeftmostButtonOnCurrentLine: Int = 0
            var runningWidth: CGFloat = 0.0
            let maxWidth: CGFloat = UIScreen.main.bounds.size.width
            let horizontalSpaceBetweenButtons: CGFloat = 8.0
            let verticalSpaceBetweenButtons: CGFloat = 1.5
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
               
                addTitle_btn.translatesAutoresizingMaskIntoConstraints = false
                let attrStr = NSMutableAttributedString(string: "\(addTitle_btn.title(for: .normal) ?? "")")
               
                if(i != 0)
                {
                    attrStr.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 2))
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
                        let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .top, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .bottom, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
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
            orderviewheight.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 70 : 40

            if(commonArray.count > 0)
            {
                commonArray.removeAll { $0 == "" }
                Constant.showInActivityIndicatory()
                tag_tbl.reloadData()
                

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
           // self.commonArray.append(contentsOf: filteredEvents)
        }
        func getsportsmethod()
           {
               self.getSameSportsArray = NSMutableArray()
               self.getdifferentSportsArray = NSMutableArray()
               
               if(self.getdifferentOrganization.count > 1)
               {
                   //self.addorderArray.add(commonArray.last!)
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
                  // self.addorderArray.add(commonArray.last!)
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
                   //self.addorderArray.add(commonArray.last!)
                   self.commonArray = NSMutableArray() as? [String]

                       for i in 0..<getdifferentSportsArray.count
                       {
                                         let roleDic: NSDictionary = getdifferentSportsArray?[i] as! NSDictionary
                                         let role: String = roleDic.value(forKey: "sport_id") as! String
                                         if(role == getSport)
                                         {
                                             self.getSeason = roleDic.value(forKey: "season_label") as? String
                                             getSameSeasonArray.add(roleDic)
                                          getrolebySeasonid = roleDic.value(forKey: "season_id") as? String

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
                          // self.addorderArray.add(commonArray.last!)

                              self.commonArray = NSMutableArray() as? [String]
                              for i in 0..<getSameSportsArray.count
                              {
                                  let roleDic: NSDictionary = getSameSportsArray?[i] as! NSDictionary
                                  let role: String = roleDic.value(forKey: "sport_id") as! String
                                  if(role == getSport)
                                  {
                                      self.getSeason = roleDic.value(forKey: "season_label") as? String
                                      getSameSeasonArray.add(roleDic)
                                      getrolebySeasonid = roleDic.value(forKey: "season_id") as? String

                                      }
                                      else
                                      {
                                          getdifferentSeasonArray.add(roleDic)
                                          }
                              
                              }
                            
                            if(getdifferentSeasonArray.count > 1)
                              {
                                  var filteredEvent: [String] = self.getdifferentSeasonArray.value(forKeyPath: "@distinctUnionOfObjects.season_label") as! [String]
                                filteredEvent.sort()
                                  self.commonArray.append(contentsOf: filteredEvent)

                              }
                             else
                            {
                                   var filteredEvent: [String] = self.getSameSeasonArray.value(forKeyPath: "@distinctUnionOfObjects.season_label") as! [String]
                                filteredEvent.sort()
                                  self.commonArray.append(contentsOf: filteredEvent)

                              }
//                           var filteredEvents: [String] = self.getSameSportsArray.value(forKeyPath: "@distinctUnionOfObjects.season_label") as! [String]
//                            filteredEvents.sort()
//                           self.commonArray.append(contentsOf: filteredEvents)

                          }
           }
         
           func getTeammethod()
           {
                if(self.getdifferentSeasonArray.count > 1)
                        {
                           //self.addorderArray.add(commonArray.last!)

                          self.commonArray = NSMutableArray() as? [String]
                            var filteredEvents: [String] = self.getdifferentSeasonArray.value(forKeyPath: "@distinctUnionOfObjects.team_name") as! [String]
                            filteredEvents.sort()
                            self.commonArray.append(contentsOf: filteredEvents)
                            

                        }
                else
                 {
                    if(self.getSameSeasonArray.count > 0)
                   {
                       
                       //self.addorderArray.add(commonArray.last!)

                                      self.commonArray = NSMutableArray() as? [String]
                        var filteredEvents: [String] = self.getSameSeasonArray.value(forKeyPath: "@distinctUnionOfObjects.team_name") as! [String]
                    filteredEvents.sort()
                                        self.commonArray.append(contentsOf: filteredEvents)
                                        

                                    }
                }
           }
        @objc func orderselectmethod(_ sender: UIButton)
        {
            let selecttag = sender.tag
            isTeam = false
            createGroupView.isHidden = true
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
                //self.addorderArray = NSMutableArray()
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
               // self.addorderArray = NSMutableArray()
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
              //  self.addorderArray = NSMutableArray()
                getorganization()
                getsportsmethod()
                getSeasonmethod()
                getTeammethod()
               // getLevelmethod()
                for i in 0..<addorderArray.count
                           {
                               if(i>3)
                               {
                                 self.addorderArray.removeLastObject()
                               }
                           }
                getuserDetail()
            }
            else if (selecttag == 4)
            {
               // self.addorderArray = NSMutableArray()
                getorganization()
                getsportsmethod()
                getSeasonmethod()
               // getLevelmethod()
                getTeammethod()
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
            cell.textLabel?.textColor = UIColor.blue
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
                cell.username_lbl?.text = dic.value(forKey: "tag_name") as? String
                cell.delete_enable_img.tintColor = (count > 0) ? UIColor.gray : UIColor.red
                
                let used : Bool = dic.value(forKey: "is_used") as! Bool

                if(used == true)
                {
                   cell.delete_enable_img.tintColor =  UIColor.gray
                    //cell.accessoryType = .disclosureIndicator

                }
                else
                {
                    cell.delete_enable_img.tintColor =  UIColor.red
                   // cell.accessoryType = .disclosureIndicator

                }
                
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
                    self.addorderArray.add(commonArray.last!)
                    getSeasonmethod()
                    self.addorderArray.add(commonArray.last!)
                    getTeammethod()
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
                    self.addorderArray.add(commonArray.last!)
                    getTeammethod()

                }
                else if(addorderArray.count == 3)
                           {
                               for i in 0..<self.getRolebyreasonDetailArray.count
                               {
                                    let roleDic: NSDictionary = getRolebyreasonDetailArray?[i] as! NSDictionary
                                    let role: String = roleDic.value(forKey: "sport_name") as! String
                                   if(self.commonArray[indexPath.row] == role && roleDic.value(forKey: "sport_id") as? String == getSport)
                                   {
                                       getTeamId = roleDic.value(forKey: "team_id") as? String

                                   }
                               }
                               self.addorderArray.add(commonArray[indexPath.row])
                                getTeammethod()

                           }
            getuserDetail()

            }

            else
            {
               print(getSeason)
               self.addorderArray.add("\(self.commonArray[indexPath.row])")
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
                //orderviewheight.constant = 90

                if (UserDefaults.standard.bool(forKey: "tag_custom") == true)
                {
                    sorting.isHidden = false
                }
                else
                {
                    sorting.isHidden = true
                }
                getTagListMethod()
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
                Constant.showAlertMessage(vc: self, titleStr: "Unable To Delete", messageStr: "Tag Is Tied With Feed, So Can't Able To Delete")
            }
            else
            {
                let alert = UIAlertController(title: " Delete Tag? ", message: "Are You Sure Want To Delete \(teamDic.value(forKey: "tag_name")!)".capitalized, preferredStyle: UIAlertController.Style.alert);
                alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { _ in
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
            let docRef = db.collection("users").document("\(getuuid!)")
            
            docRef.collection("roles_by_season").whereField("role", isEqualTo:self.getSelectRole).getDocuments() { (querySnapshot, err) in
                
                Constant.showInActivityIndicatory()

                   if let err = err {
                       print("Error getting documents: \(err)")
                     Constant.showInActivityIndicatory()
                   } else {
                     Constant.showInActivityIndicatory()
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
                                        Constant.showInActivityIndicatory()

                                    }
                                }
                                
                            }

                          }

                    if(self.getRolebyreasonDetailArray.count > 0)
                    {
                        self.getorganization()
                        if(self.getSameOrganization.count > 0 && self.getdifferentOrganization.count == 0)
                        {
                            self.addorderArray.add(self.commonArray.last!)
                             self.getsportsmethod()
                            
                            if(self.getSameSportsArray.count > 0 && self.getdifferentSportsArray.count == 0)
                            {
                                self.addorderArray.add(self.commonArray.last!)
                                self.getSeasonmethod()
                                
                                if(self.getSameSeasonArray.count > 0 && self.getdifferentSeasonArray.count == 0)
                                {
                                    self.addorderArray.add(self.commonArray.last!)
                                    self.getTeammethod()
                                }

                            }
                        }

                        self.getuserDetail()


                    }
                      

                           }
                       }
        }
    
    func getTagListMethod()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
               let getuuid = UserDefaults.standard.string(forKey: "UUID")
                let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(getrolebySeasonid!)")
                            if (UserDefaults.standard.bool(forKey: "tag_user") == true)
                            {
                                
                            docRef.collection("Tags").order(by: "count", descending: true).getDocuments() { (querySnapshot, err) in
                               // Constant.showInActivityIndicatory()

                            if let err = err {
                            print("Error getting documents: \(err)")
                            Constant.showInActivityIndicatory()

                            } else {
                            self.TeamArray = NSMutableArray()
                            
                            for document in querySnapshot!.documents {
                            let data: NSDictionary = document.data() as NSDictionary
                            
                            self.TeamArray.add(data)
                            
                            }
                            self.isTeam = true
                            self.createGroupView.isHidden = (self.TeamArray.count == 0) ? true : false
                            self.tag_tbl.reloadData()
                           Constant.showInActivityIndicatory()
                            
                                }
                            }
                        }
                      else if(UserDefaults.standard.bool(forKey: "tag_team") == true)
                    {
                         let docRefteam = db.collection("teams").document("\(getTeamId!)")
                        docRefteam.collection("Tags").order(by: "count", descending: true).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                        print("Error getting documents: \(err)")
                        } else {
                        self.TeamArray = NSMutableArray()
                        
                        for document in querySnapshot!.documents {
                        let data: NSDictionary = document.data() as NSDictionary
                        
                        self.TeamArray.add(data)
                        
                        }
                        self.isTeam = true
                        self.createGroupView.isHidden = (self.TeamArray.count == 0) ? true : false
                        self.tag_tbl.reloadData()
                        Constant.showInActivityIndicatory()
                        
                            }
                        }
                    }
                        else
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
                                                                self.createGroupView.isHidden = (self.TeamArray.count == 0) ? true : false
                                                                self.tag_tbl.reloadData()
                                                               Constant.showInActivityIndicatory()
                            
                                                            }
                                                        }
                                        }
    }
    
    func checkTimeStamp(date: String!) -> Bool {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        let datecomponents = dateFormatter.date(from: date)

        let now = Date()

        if (datecomponents! >= now) {
            return true
        } else {
            return false
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
                       Constant.showInActivityIndicatory()

                        if let err = err {
                            print("Error removing document: \(err)")
                          // Constant.showInActivityIndicatory()

                        } else {
                            print("Document successfully removed!")
                           let docrefs = db.collection("teams").document("\(self.getTeamId!)")
                            docrefs.collection("Tags").document("\(rolebyDic.value(forKey: "tag_id")!)").delete()
                            { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                   //Constant.showInActivityIndicatory()

                                } else {
                                    print("Document successfully removed!")
                                            print("Document successfully removed!")
                                            Constant.showInActivityIndicatory()
                                            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "\(rolebyDic.value(forKey: "tag_name")!) Removed Successfully")
                                          
                                            self.getTagListMethod()
                                    }
                            }
                            //Constant.showInActivityIndicatory()
                        }
                    }
    }
//     {
//
//        let tagtitle: String = rolebyDic.value(forKey: "tag_name") as! String
//          Constant.internetconnection(vc: self)
//          Constant.showActivityIndicatory(uiView: self.view)
//          let getuuid = UserDefaults.standard.string(forKey: "UUID")
//          let db = Firestore.firestore()
//        if(UserDefaults.standard.bool(forKey: "tag_team") == true)
//        {
//             let docRefteam = db.collection("teams").document("\(getTeamId!)")
//            docRefteam.collection("Tags").getDocuments() { (querySnapshot, err) in
//                    //Constant.showInActivityIndicatory()
//
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                      let getTagDelete = NSMutableArray()
//                        for document in querySnapshot!.documents {
//                        let data: NSDictionary = document.data() as NSDictionary
//                          if(data.value(forKey: "tag_name") as! String == tagtitle || (data.value(forKey: "tag_name") as! String) . caseInsensitiveCompare(tagtitle) == ComparisonResult.orderedSame)
//                          {
//                              getTagDelete.add(data)
//
//                          }
//
//                       }
//                    if(getTagDelete.count > 0)
//                    {
//                        docRefteam.collection("Tags").document("\(rolebyDic.value(forKey: "tag_id")!)").delete()
//                        { err in
//                            if let err = err {
//                                print("Error removing document: \(err)")
//                                Constant.showInActivityIndicatory()
//
//                            } else {
//                                print("Document roleby season successfully removed!")
//
//                                let teamRef = db.collection("teams").document("\(self.getTeamId!)")
//                                teamRef.collection("Tags").getDocuments{ (querySnapshot, err) in
//                                if let err = err {
//                                print("Error getting documents: \(err)")
//                                    Constant.showInActivityIndicatory()
//
//                                                           } else {
//
//                                let getteamsTagList = NSMutableArray()
//
//                                for document in querySnapshot!.documents {
//                                let data: NSDictionary = document.data() as NSDictionary
//                                if(data.value(forKey: "tag_name") as! String == tagtitle || (data.value(forKey: "tag_name") as! String) . caseInsensitiveCompare(tagtitle) == ComparisonResult.orderedSame)
//                                {
//                                    getteamsTagList.add(data)
//
//                                }
//                            }
//                            if(getteamsTagList.count > 0)
//                            {
//                                teamRef.collection("Tags").document("\(rolebyDic.value(forKey: "tag_id")!)").delete()
//                                { err in
//                                if let err = err {
//                                    print("Error removing document: \(err)")
//                                } else {
//                                    print("Document roleby season successfully removed!")
//                                    Constant.showInActivityIndicatory()
//                                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "\(rolebyDic.value(forKey: "tag_name")!) Removed Successfully")
//                                    self.getTagListMethod()
//                                    Constant.showInActivityIndicatory()
//                                    }
//                                }
//                            }
//                            }
//                                }
//                            }
//                        }
//                    }
//                    else{
//                       // Constant.showInActivityIndicatory()
//                        Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Deleted Successfully")
//                        self.getTagListMethod()
//                        //Constant.showInActivityIndicatory()
//                    }
//
//                    }
//            }
//        }
//
//        else
//        {
//             let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(getrolebySeasonid!)")
//                docRef.collection("Tags").getDocuments() { (querySnapshot, err) in
//                    //Constant.showInActivityIndicatory()
//
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                      let getTagDelete = NSMutableArray()
//                        for document in querySnapshot!.documents {
//                        let data: NSDictionary = document.data() as NSDictionary
//                          if(data.value(forKey: "tag_name") as! String == tagtitle || (data.value(forKey: "tag_name") as! String) . caseInsensitiveCompare(tagtitle) == ComparisonResult.orderedSame)
//                          {
//                              getTagDelete.add(data)
//
//                          }
//
//                       }
//                    if(getTagDelete.count > 0)
//                    {
//                        docRef.collection("Tags").document("\(rolebyDic.value(forKey: "tag_id")!)").delete()
//                        { err in
//                            if let err = err {
//                                print("Error removing document: \(err)")
//                                Constant.showInActivityIndicatory()
//
//                            } else {
//                                print("Document roleby season successfully removed!")
//
//                                let teamRef = db.collection("teams").document("\(self.getTeamId!)")
//                                teamRef.collection("Tags").getDocuments{ (querySnapshot, err) in
//                                if let err = err {
//                                print("Error getting documents: \(err)")
//                                    Constant.showInActivityIndicatory()
//
//                                                           } else {
//
//                                let getteamsTagList = NSMutableArray()
//
//                                for document in querySnapshot!.documents {
//                                let data: NSDictionary = document.data() as NSDictionary
//                                if(data.value(forKey: "tag_name") as! String == tagtitle || (data.value(forKey: "tag_name") as! String) . caseInsensitiveCompare(tagtitle) == ComparisonResult.orderedSame)
//                                {
//                                    getteamsTagList.add(data)
//
//                                }
//                            }
//                            if(getteamsTagList.count > 0)
//                            {
//                                teamRef.collection("Tags").document("\(rolebyDic.value(forKey: "tag_id")!)").delete()
//                                { err in
//                                if let err = err {
//                                    print("Error removing document: \(err)")
//                                } else {
//                                    print("Document roleby season successfully removed!")
//                                    Constant.showInActivityIndicatory()
//                                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "\(rolebyDic.value(forKey: "tag_name")!) Removed Successfully")
//                                    self.getTagListMethod()
//                                    Constant.showInActivityIndicatory()
//                                    }
//                                }
//                            }
//                            }
//                                }
//                            }
//                        }
//                    }
//                    else{
//                       // Constant.showInActivityIndicatory()
//                        Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Deleted Successfully")
//                        self.getTagListMethod()
//                        //Constant.showInActivityIndicatory()
//                    }
//
//                    }
//            }
//                }
//
//              }
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
        vc.delegate = self
        vc.getorganizationDetails = self.getRolebyreasonDetailArray
        vc.rolebySeasonid = self.getrolebySeasonid as NSString?
        vc.getTeamId = self.getTeamId as NSString?
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension String{
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin], attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
