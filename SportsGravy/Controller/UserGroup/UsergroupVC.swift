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
import ResizingTokenField

class UsergroupVC: UIViewController, SWRevealViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, CreateusergroupDelegate, SortorderDelegate {
    
    class Token: ResizingTokenFieldToken, Equatable {
           
           static func == (lhs: Token, rhs: Token) -> Bool {
               return lhs === rhs
           }
           
           var title: String
           
           init(title: String) {
               self.title = title
           }
       }
    
    
    func sortingOrderTagupdateSuccess() {
        
    }
    
    func sortingOrderUsergroupupdateSuccess() {
        getmembergroupDetail()
    }
    
    func sortingOrderCannedupdateSuccess() {
        
    }
    
    func passorderArray(select: NSMutableArray!, selectindex: UIButton) {
        self.addorderArray = select
        addTitle_btn.tag = selectindex.tag
        addTitle_btn.sendActions(for:  .touchUpInside)
        
    }
    
    func createAfterCallMethod() {
        getmembergroupDetail()
    }

    @IBOutlet var addorderview: UIView!
    @IBOutlet weak var usergroup_tbl: UITableView!
    @IBOutlet weak var createGroupView: UIView!
    @IBOutlet weak var sortingUser: UIButton!
    @IBOutlet weak var create_btn: UIButton!


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
    var getTeamId: String!
    var isCreate : Bool!
    
    var getSelectRole: String!
    var getOrganization: String!
    var getSport: String!
    var getSportname: String!

    var getSeason: String!
    var getLevel: String!
    var getLevelId: String!
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
        self.getdifferentSportsArray = NSMutableArray()
        self.getdifferentSeasonArray = NSMutableArray()
        self.getdifferentLevelArray = NSMutableArray()

        getmembergroup()
//        getorganization()
//        getsportsmethod()
//        getSeasonmethod()
//        getTeammethod()
//        getuserDetail()
        createGroupView.isHidden = true
        sortingUser.isHidden = true
        self.usergroup_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.usergroup_tbl.contentInset = UIEdgeInsetsMake(0,-3, 0, 0);

        self.usergroup_tbl.sizeToFit()

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
           self.addOrder.frame =  self.addorderview.bounds

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
                    buttons.add(self.addTitle_btn)
                    
                    
                }

            }
        self.addorderview.addSubview(self.addOrder)

       // let globalPoint = addOrder.superview?.convert(addTitle_btn.frame.origin, to: nil)
        print("heightcustom:\(indexOfLeftmostButtonOnCurrentLine)")

        self.orderviewheight.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 70 : 40

            
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
        let filteredEvents: [String] = self.getRolebyreasonDetailArray.value(forKeyPath: "@distinctUnionOfObjects.organization_id") as! [String]
        
                   for i  in 0..<getRolebyreasonDetailArray.count
                   {
                   let roleDic: NSDictionary = getRolebyreasonDetailArray?[i] as! NSDictionary
       //
                   let abb: String = roleDic.value(forKey: "organization_id") as! String
                   if (filteredEvents.contains("\(abb)"))
                   {
                       print("found")
                    getOrganization = roleDic.value(forKey: "organization_id") as? String
                    
                       getSameOrganization.add(roleDic)

                   }
                   else
                   {
                       print("not found")
                    getOrganization = roleDic.value(forKey: "organization_id") as? String
                     
                       getdifferentOrganization.add(roleDic)
                   }
                       
                   }
        if(getdifferentOrganization.count > 1)
        {
            var filteredEvent =  self.getdifferentOrganization.value(forKeyPath: "@distinctUnionOfObjects.organization_abbrev") as! [String]
              filteredEvent.sort()
            self.commonArray.append(contentsOf: filteredEvent)

        }
        else
        {
           
            var filteredEvent = self.getSameOrganization.value(forKeyPath: "@distinctUnionOfObjects.organization_abbrev") as! [String]
            filteredEvent.sort()
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
                var filteredEvent: [String] = self.getdifferentSportsArray.value(forKeyPath: "@distinctUnionOfObjects.sport_name") as! [String]
                filteredEvent.sort()
                self.commonArray.append(contentsOf: filteredEvent)

            }
           else
          {
            var filteredEvent: [String] = self.getSameSportsArray.value(forKeyPath: "@distinctUnionOfObjects.sport_name") as! [String]
                filteredEvent.sort()
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
            if(getdifferentSportsArray.count > 1)
              {
                  var filteredEvent: [String] = self.getdifferentSportsArray.value(forKeyPath: "@distinctUnionOfObjects.sport_name") as! [String]
                filteredEvent.sort()
                  self.commonArray.append(contentsOf: filteredEvent)

              }
             else
            {
                var filteredEvent: [String] = self.getSameSportsArray.value(forKeyPath: "@distinctUnionOfObjects.sport_name") as! [String]
                filteredEvent.sort()
                  self.commonArray.append(contentsOf: filteredEvent)

              }
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
                    
                   }
    }
  
    func getTeammethod()
    {
         if(self.getdifferentSeasonArray.count > 1)
                 {

                   self.commonArray = NSMutableArray() as? [String]
                     var filteredEvents: [String] = self.getdifferentSeasonArray.value(forKeyPath: "@distinctUnionOfObjects.team_name") as! [String]
                    filteredEvents.sort()
                     self.commonArray.append(contentsOf: filteredEvents)
                     

                 }
         else
          {
             if(self.getSameSeasonArray.count > 0)
            {
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
        self.isTeam = false
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
            getorganization()
            getsportsmethod()
            getSeasonmethod()
            getTeammethod()
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
           return 75.0
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
            if(groupType != "System_Group")
            {
                let count : Bool = dic.value(forKey: "is_used") as! Bool

                if(count == true)
                {
                   cell.delete_enable_img.tintColor =  UIColor.gray
                    cell.accessoryType = .disclosureIndicator

                }
                else
                {
                    cell.delete_enable_img.tintColor =  UIColor.red
                    cell.accessoryType = .disclosureIndicator

                }
            }
            else
            {
                cell.delete_enable_img.tintColor =  UIColor.gray
                cell.accessoryType = .none
            }
            

            cell.username_lbl?.text = "\(filtered)"
            cell.selectionStyle = .none

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
            if (UserDefaults.standard.bool(forKey: "user_group_custom") == true)
            {
                sortingUser.isHidden = false

            }
            else
            {
                sortingUser.isHidden = true

            }
            getmembergroupDetail()
        }
        }
        else
        {
            let dic: NSDictionary = TeamArray?[indexPath.row] as! NSDictionary
            //let userArray: NSMutableArray = dic.value(forKey: "user_list") as! NSMutableArray
            let count : Bool = dic.value(forKey: "is_used") as! Bool
            let groupType : String = dic.value(forKey: "group_type") as! String
            if(count == true && groupType == "System_Group")
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
        let count : Bool = teamDic.value(forKey: "is_used") as! Bool
        let groupType : String = teamDic.value(forKey: "group_type") as! String
        let isDelete: Bool = (count != false || groupType == "System_Group") ? false : true
        if(isDelete == false)
        {
            Constant.showAlertMessage(vc: self, titleStr: "Unable To Delete", messageStr: "Usergroup is tied with feed, So can't able to delete")
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
                        let getseason_end_date =  data.value(forKey: "season_end_date") as! Timestamp
                        let season_end_Date = getseason_end_date.dateValue()
                        //print(season_end_Date)
                        //let seasonendformatter = DateFormatter()
                       
                        let season_endDate:NSDate = season_end_Date as NSDate
                        let dateFormatter:DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let endString:String = dateFormatter.string(from: season_endDate as Date)
                        
                       // let seasonendstring: String = endString
                        //let stringdateformate: DateFormatter = DateFormatter()
                        //let seasonenddate: NSDate = stringdateformate.date(from: endString)! as NSDate
                        
                        
                        
                        let getSeason_start_date = data.value(forKey: "season_start_date") as! Timestamp
                        let season_start_Date = getSeason_start_date.dateValue()
                        
                        let season_startDate:NSDate = season_start_Date as NSDate
                        let dateFormatters:DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let startString:String = dateFormatters.string(from: season_startDate as Date)
                        
                       // let endstringdateformate: DateFormatter = DateFormatter()
                        //let seasonstartdate: NSDate = (endstringdateformate.date(from: startString) as NSDate?)!
                        
                    
                       // print(season_start_Date)

                        //print("\(document.documentID) => \(getseason_end_date)")
                        if(data.value(forKey: "team_id") as? String != nil && data.value(forKey: "team_id")as! String != "")
                        {
                            if(endString != nil   && startString != nil )
                            {
                                //let enddate = NSDate(timeIntervalSince1970: getseason_end_date!)
                               // print("enddate:\(enddate)")
                                //let startDate = NSDate(timeIntervalSince1970:getSeason_start_date!)
                                // print("startDate:\(startDate)")
                                //let currentDate = Date()  as Date
                                //print("currentDate:\(currentDate ?? nil)")
                                let todaysDate:NSDate = NSDate()
                                let dateFormatter:DateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                               // let todayString:String = dateFormatter.string(from: todaysDate as Date)
                                
                                if(season_endDate.timeIntervalSinceNow  > todaysDate.timeIntervalSinceNow  || season_startDate.timeIntervalSinceNow < todaysDate.timeIntervalSinceNow)
                                {
                                        print("yes")
                                    self.getRolebyreasonDetailArray.add(data)
                                    print("\(document.documentID) => \(season_endDate)")
                                     print("\(document.documentID) => \(season_startDate)")
                                     print("\(document.documentID) => \(todaysDate)")

                                }
//                                else{
//                                    print("no")
//                                }
                            }
                            else
                            {
                                print("seasondate nil")
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
    
    func getmembergroupDetail()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(getrolebySeasonid!)")
    if (UserDefaults.standard.bool(forKey: "user_group_user") == true)
    {
docRef.collection("MemberGroup").order(by: "count", descending: true).getDocuments() { (querySnapshot, err) in
    Constant.showInActivityIndicatory()

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
                                    self.createGroupView.isHidden = (self.TeamArray.count == 0) ? true: false
                                    self.usergroup_tbl.reloadData()
                                  //  Constant.showInActivityIndicatory()
        
        
                                }
                            }
                }
      
        else if(UserDefaults.standard.bool(forKey: "user_group_team") == true)
    {
         let docRefteam = db.collection("teams").document("\(getTeamId!)")
        docRefteam.collection("MemberGroup").order(by: "count", descending: true).getDocuments() { (querySnapshot, err) in
                                 if let err = err {
                                     print("Error getting documents: \(err)")
                                    Constant.showInActivityIndicatory()

                                 } else {
                                    self.TeamArray = NSMutableArray()
                                     for document in querySnapshot!.documents {
                                         let data: NSDictionary = document.data() as NSDictionary
                                         print("\(document.documentID) => \(data)")
                                        self.TeamArray.add(data)
                                    }
                                    self.isTeam = true
                                    self.createGroupView.isHidden = (self.TeamArray.count == 0) ? true: false
                                    self.usergroup_tbl.reloadData()
                                    Constant.showInActivityIndicatory()
                                }
                            }
    }
        
                else
                {
                    docRef.collection("MemberGroup").order(by: "updated_datetime", descending: false).getDocuments() { (querySnapshot, err) in
                                            if let err = err {
                                                print("Error getting documents: \(err)")
                                                Constant.showInActivityIndicatory()

                                            } else {
                                               self.TeamArray = NSMutableArray()
        
                                                for document in querySnapshot!.documents {
                                                    let data: NSDictionary = document.data() as NSDictionary
                                                    print("\(document.documentID) => \(data)")
//                                                    if(data.value(forKey: "role") as? String == self.getSelectRole)
//                                                    {
                                                   self.TeamArray.add(data)
                                                    //}
                                               }
                                               self.isTeam = true
                                                self.createGroupView.isHidden = (self.TeamArray.count == 0) ? true : false
                                               self.usergroup_tbl.reloadData()
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
                Constant.showInActivityIndicatory()

                 if let err = err {
                     print("Error removing document: \(err)")
                   // Constant.showInActivityIndicatory()

                 } else {
                     print("Document successfully removed!")
                    let docrefs = db.collection("teams").document("\(self.getTeamId!)")
                     docrefs.collection("MemberGroup").document("\(rolebyDic.value(forKey: "user_groupId")!)").delete()
                     { err in
                         if let err = err {
                             print("Error removing document: \(err)")
                            //Constant.showInActivityIndicatory()

                         } else {
                             print("Document successfully removed!")
                                     print("Document successfully removed!")
                                     Constant.showInActivityIndicatory()
                                     Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "User Group Removed Successfully")
                                   
                                     self.getmembergroupDetail()
                             }
                     }
                     //Constant.showInActivityIndicatory()
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
        vc.delegate = self
        vc.rolebySeasonid = self.getrolebySeasonid as NSString?
        vc.getTeamId = self.getTeamId as NSString?
        vc.selectType = "MemberGroup"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
