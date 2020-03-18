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



class CannedResponseVC: UIViewController, UITableViewDataSource, UITableViewDelegate, SWRevealViewControllerDelegate,CreateCanresponseDelegate, SortorderDelegate {
    func sortingOrderTagupdateSuccess() {
        
    }
    
    func sortingOrderUsergroupupdateSuccess() {
        
    }
    
    func sortingOrderCannedupdateSuccess() {
        getCannedresponsegroupDetail()
    }
    
    func passorderArray(select: NSMutableArray!, selectindex: UIButton) {
        self.addorderArray = select
        addTitle_btn.tag = selectindex.tag
        addTitle_btn.sendActions(for:  .touchUpInside)
    }
    func createAfterCallMethod() {
        getCannedresponsegroupDetail()
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
    var getSameLevelArray: NSMutableArray!
    var getdifferentLevelArray: NSMutableArray!
    var addorderArray: NSMutableArray!
    var commonArray: [String]!
    var getTeamId: String!

    
    var getSelectRole: String!
    var getOrganization: String!
    var getSport: String!
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
        canned_response_tbl.delegate = self
        canned_response_tbl.dataSource = self
        commonArray = NSMutableArray() as? [String]
        canned_response_tbl.tableFooterView = UIView()
        self.addorderArray = NSMutableArray()
        getCannedresponsegroup()
//        getorganization()
//        getsportsmethod()
//        getSeasonmethod()
//        getTeammethod()
//        getuserDetail()
        createGroupView.isHidden = true
        sortingCanned.isHidden = true
        self.canned_response_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.canned_response_tbl.sizeToFit()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func getuserDetail()
    {
        self.orderviewheight.constant = (self.addorderArray.count > 5) ? 90 : 50

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
    
                addTitle_btn.titleLabel?.font = UIFont(name: "Arial", size: 18)
                let title: String = addorderArray?[i] as! String

                if(title != "" && title != nil)
                {
                if(i == 0)
                {
                    self.addTitle_btn.setTitle("\(addorderArray[i] as! String)", for: .normal)
                }
                else
                {
                    addTitle_btn.setTitle("> \(addorderArray[i] as! String)", for: .normal)

                }
               // addTitle_btn.setTitle("\(addorderArray[i] as! String)", for: .normal)
//                let title: String = addorderArray?[i] as! String
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
                            
                            //[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop              multiplier:1.0f constant:verticalSpaceBetweenButtons];
                                    //   [self.view addConstraint:verticalConstraint];

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
                    let filteredEvents: [String] = self.getRolebyreasonDetailArray.value(forKeyPath:
                        "@distinctUnionOfObjects.organization_id") as! [String]
        
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
                        var filteredEvents: [String] = self.getSameSportsArray.value(forKeyPath: "@distinctUnionOfObjects.season_label") as! [String]
                        filteredEvents.sort()
                       self.commonArray.append(contentsOf: filteredEvents)

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
        //orderviewheight.constant = 50
        isTeam = false
        createGroupView.isHidden = true

        if(selecttag == 0)
        {
            print("All")
            //self.addorderArray = NSMutableArray()

           getorganization()
            getuserDetail()
        }
        else if(selecttag == 1)
        {
            print("organization")
           // self.addorderArray = NSMutableArray()

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
            self.addorderArray = NSMutableArray()
            getorganization()
            getsportsmethod()
            getSeasonmethod()
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
           self.addorderArray = NSMutableArray()
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
           return 90.0
        }
     }

            // create a cell for each table view row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(isTeam == false)
        {
        let cell: UITableViewCell = self.canned_response_tbl.dequeueReusableCell(withIdentifier: "can_respons_user")!
        cell.textLabel?.text = commonArray?[indexPath.row]
            cell.textLabel?.textColor = UIColor.blue
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
            cell.accessoryType =  .disclosureIndicator //(count > 0) ? .none : 

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
                                   getTeamId = roleDic.value(forKey: "team_id") as? String

                               }
                           }
                           self.addorderArray.add(commonArray[indexPath.row])
                            getTeammethod()

                       }
//        self.addorderArray = NSMutableArray()
//        getorganization()
//        getsportsmethod()
//        getSeasonmethod()
//       // getLevelmethod()
//        getTeammethod()
        getuserDetail()

        }

        else
        {
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
//
           // orderviewheight.constant = 90
            if (UserDefaults.standard.bool(forKey: "3") == true)
                {
                    self.sortingCanned.isHidden = false

                }
            else
            {
                self.sortingCanned.isHidden = true

            }
            getCannedresponsegroupDetail()
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
            Constant.showAlertMessage(vc: self, titleStr: "Unable To Delete", messageStr: "system generated user group cant able to delete")
        }
        else
        {
            let alert = UIAlertController(title: " Delete Canned Response? ", message: "Are you sure want to delete \(teamDic.value(forKey: "cannedResponseTitle")!)", preferredStyle: UIAlertController.Style.alert);
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
       let docRef = db.collection("users").document("\(getuuid!)")
                   
                   docRef.collection("roles_by_season").whereField("role", isEqualTo:self.getSelectRole).getDocuments() { (querySnapshot, err) in
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
                              // self.getsportsmethod()
                               //self.getSeasonmethod()
                             //  self.getLevelmethod()
                              // self.getTeammethod()
                               self.getuserDetail()
                           }
                              Constant.showInActivityIndicatory()
                        }
                    }
                   
  //      if (UserDefaults.standard.bool(forKey: "3") == true)
//                   {
//                    docRef.collection("CannedResponse").order(by: "updated_datetime", descending: false).getDocuments() { (querySnapshot, err) in
//                         if let err = err {
//                             print("Error getting documents: \(err)")
//                         } else {
//                            self.TeamArray = NSMutableArray()
//
//                             for document in querySnapshot!.documents {
//                                 let data: NSDictionary = document.data() as NSDictionary
//                                self.TeamArray.add(data)
//
//
//                            }
//                            self.isTeam = true
//                            self.createGroupView.isHidden = (self.TeamArray.count == 0) ? true : false
//                            self.canned_response_tbl.reloadData()
//                            Constant.showInActivityIndicatory()
//
//                        }
//                    }
//        }
     //   else
//        {
//            docRef.collection("CannedResponse").order(by: "count", descending: true).getDocuments() { (querySnapshot, err) in
//                                    if let err = err {
//                                        print("Error getting documents: \(err)")
//                                    } else {
//                                       self.TeamArray = NSMutableArray()
//
//                                        for document in querySnapshot!.documents {
//                                            let data: NSDictionary = document.data() as NSDictionary
//                                           self.TeamArray.add(data)
//
//
//                                       }
//                                       self.isTeam = true
//                                       self.createGroupView.isHidden = (self.TeamArray.count == 0) ? true : false
//                                       self.canned_response_tbl.reloadData()
//                                       Constant.showInActivityIndicatory()
//
//                                   }
//                               }
//        }
    }
    
    func getCannedresponsegroupDetail()
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
                                    self.createGroupView.isHidden = (self.TeamArray.count == 0) ? true : false
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
                                               self.createGroupView.isHidden = (self.TeamArray.count == 0) ? true : false
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
    let teamRef = db.collection("teams").document("\(getTeamId!)")
        teamRef.collection("CannedResponse").document("\(rolebyDic.value(forKey: "cannedResponseTitle_id")!)").delete()
        { err in
            if let err = err {
                print("Error removing document: \(err)")
                Constant.showInActivityIndicatory()

            } else {
                print("Document successfully removed!")
                
                let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(self.getrolebySeasonid!)")
                  docRef.collection("CannedResponse").document("\(rolebyDic.value(forKey: "cannedResponseTitle_id")!)").delete()
                { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    Constant.showInActivityIndicatory()

                } else {
                    Constant.showInActivityIndicatory()
                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "\(rolebyDic.value(forKey: "cannedResponseTitle")!) Removed Successfully")
                                 
                    self.getCannedresponsegroupDetail()
                        Constant.showInActivityIndicatory()
                    print("Document successfully removed!")
                    }
                    Constant.showInActivityIndicatory()

                }
                
               


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
        vc.delegate = self
           vc.selectType = "CannedResponse"
        vc.getorganizationDetails = getRolebyreasonDetailArray
        vc.rolebySeasonid = self.getrolebySeasonid as NSString?
        vc.getTeamId = self.getTeamId as NSString?
           self.navigationController?.pushViewController(vc, animated: true)
       }
}
