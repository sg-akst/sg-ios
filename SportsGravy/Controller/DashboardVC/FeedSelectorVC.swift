//
//  FeedSelectorVC.swift
//  SportsGravy
//
//  Created by CSS on 03/03/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

protocol FeedSelectorDelegate: AnyObject {
    func feddSelectDetail(userDetail: NSMutableArray, selectitemname: String)
    func feedselectDashboard(selectitem: NSDictionary, selectName: String)

}


class FeedSelectorVC: UIViewController, UITableViewDelegate, UITableViewDataSource, PeopleSelectorDelegate {
    func passorderArray(select: NSMutableArray!, selectindex: UIButton) {
        self.addorderArray = select
        addTitle_btn.tag = selectindex.tag
        addTitle_btn.sendActions(for:  .touchUpInside)
    }
    
    func selectPeopleSelectorDetail(userDetail: NSMutableArray) {
        let membergroup: NSDictionary = userDetail[0] as! NSDictionary
        if(membergroup.value(forKey: "membergroup_id")as! String != "")
        {
            let feedlevelobjsArray: NSMutableArray = NSMutableArray()

            if(userDetail.count > 0)
            {

                for i in 0..<userDetail.count
                {
                    let feedlevelobj : NSMutableDictionary = NSMutableDictionary()
                    let teamDic = userDetail[i]
                    if(addorderArray.count == 1)
                    {
                    feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                    feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)", forKey: "feedLevel")
                    feedlevelobjsArray.add(feedlevelobj)

                    }
                    else if(addorderArray.count == 2)
                    {
                      feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                      feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                        
                     feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)", forKey: "feedLevel")
                    }
                    else if(addorderArray.count == 3)
                    {
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                         feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                        
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")

                        
                        feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)", forKey: "feedLevel")
                    }
                    else if(addorderArray.count == 4)
                    {
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                         feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                        
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")
                        
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "level_id"), forKey: "level_id")

                        
                        feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "level_id")!)", forKey: "feedLevel")
                    }
                    else if(self.addorderArray.count == 5)
                    {
                       feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                         feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                        
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")
                        
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "level_id"), forKey: "level_id")
                        
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "team_id"), forKey: "team_id")

                        
                        feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "level_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "team_id")!)" , forKey: "feedLevel")
                    }
                    else if(self.addorderArray.count == 6)
                    {
                       feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                         feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                        
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")
                        
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "level_id"), forKey: "level_id")
                        
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "team_id"), forKey: "team_id")
                        
                        feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "membergroup_id"), forKey: "membergroup_id")
                        feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "level_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "team_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "membergroup_id")!)", forKey: "feedLevel")
                    }
                        else if(self.addorderArray.count == 7)
                        {
                           feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                             feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                            
                            feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")
                            
                            feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "level_id"), forKey: "level_id")
                            
                            feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "team_id"), forKey: "team_id")
                            
                            feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "membergroup_id"), forKey: "membergroup_id")
                            
                             feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "user_id"), forKey: "user_id")
                            feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "level_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "team_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "membergroup_id")!)" + "\((teamDic as AnyObject).value(forKey: "user_id")!)", forKey: "feedLevel")
                        }
                    
                    feedlevelobjsArray.add(feedlevelobj)

                }
                if(feedlevelobjsArray.count>0)
                {
                    if(self.addorderArray.count == 7)
                    {
                        self.delegate?.feddSelectDetail(userDetail: feedlevelobjsArray, selectitemname: membergroup.value(forKey: "user_id") as! String)
                    }
                    else
                    {
                    self.delegate?.feddSelectDetail(userDetail: feedlevelobjsArray, selectitemname: membergroup.value(forKey: "membergroup_id") as! String)
                    }
                }
            }
            
            

        }
        else
        {
        self.delegate?.feddSelectDetail(userDetail: userDetail, selectitemname: addorderArray?.lastObject as! String)
        }
      //  self.navigationController?.popViewController(animated: false)

    }
    

    
    @IBOutlet weak var feed_selector_tbl: UITableView!
    weak var delegate:FeedSelectorDelegate?

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
    var getdifferentSeasonArray: NSMutableArray!
    var getSeason: String!
    var getrolebySeasonid: String!
    var getSeasonid: String!

    var getTeamName: String!
    var getTeamId: String!
    var getLevelid: String!
    var getLevel: String!
    //var getLevelId: String!
    @IBOutlet var addorderview: UIView!
    @IBOutlet weak var orderviewheight: NSLayoutConstraint!
    var addOrder: UIView!

    var commonArray: [String]!
    var countArray: NSMutableArray!
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
        countArray = NSMutableArray()
        feed_selector_tbl.delegate = self
        feed_selector_tbl.dataSource = self
        getusergroup()
        
        feed_selector_tbl.tableFooterView = UIView()
        feed_selector_tbl.sizeToFit()
        self.feed_selector_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.feed_selector_tbl.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

       
    }
    func getuserDetail()
        {

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
            self.orderviewheight.constant = 40

            if(indexOfLeftmostButtonOnCurrentLine > 0)
            {
                self.orderviewheight.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 70 : 40
                                  
                               if(indexOfLeftmostButtonOnCurrentLine > 5)
                               {
                                          
                                self.orderviewheight.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 100 : 70
                                          
                               }
                               }

                    if(commonArray.count > 0)
                    {
                        commonArray.removeAll { $0 == "" }
                        feed_selector_tbl.reloadData()

                    }
            
            if(self.addorderArray.count < 6)
            {
                if(addorderArray.count == 1)
                {
                  print("1")
                if(getdifferentOrganization.count > 1)
                {
                    feedCount(selectArray: getdifferentOrganization)
                }
                else
                {
                    feedCount(selectArray: getSameOrganization)
                    
                 }
                }
                else if(addorderArray.count == 2)
                {
                    print("2")
                   if(getdifferentSportsArray.count > 1)
                    {
                        feedCount(selectArray: getdifferentSportsArray)
                    }
                    else
                    {
                        feedCount(selectArray: getSameSportsArray)
                    
                    }

                }
                else if(self.addorderArray.count == 3)
                {
                    if(getdifferentSeasonArray.count > 1)
                    {
                        feedCount(selectArray: getdifferentSeasonArray)
                    }
                    else
                    {
                        feedCount(selectArray: getSameSeasonArray)
                    
                    }

                }
                else if(addorderArray.count == 4)
                {
                    print("4")
                    if(getdifferentLevelArray.count > 1)
                    {
                        feedCount(selectArray: getdifferentLevelArray)
                    }
                    else
                    {
                       feedCount(selectArray: getSameLevelArray)
                    
                    }
                }
                else if(addorderArray.count == 5)
                {
                    if(getdifferentTeamArray.count >= 1)
                    {
                        feedCount(selectArray: getdifferentTeamArray)
                    }
                    else
                    {
                        feedCount(selectArray: self.getSameTeamArray)
                                       
                    }
                }
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

                            self.getdifferentOrganization.add(roleDic)
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
                self.addorderArray.add(commonArray.last!)
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
                     var filteredEvents: [String] = self.getdifferentSportsArray.value(forKeyPath: "@distinctUnionOfObjects.sport_name") as! [String]
                    filteredEvents.sort()
                                  self.commonArray.append(contentsOf: filteredEvents)
                }
                else
                {
                     var filteredEvents: [String] = self.getSameSportsArray.value(forKeyPath: "@distinctUnionOfObjects.sport_name") as! [String]
                    filteredEvents.sort()
                                  self.commonArray.append(contentsOf: filteredEvents)
                }
               
                     }
               else if(self.getSameOrganization.count > 0)
               {
                self.addorderArray.add(commonArray.last!)
                   self.commonArray = NSMutableArray() as? [String]
//                   self.addorderArray.add("\(getOrganization!)")
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
                                    self.addorderArray.add(commonArray.last!)

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
//
                                     }
                                    if(getdifferentSeasonArray.count > 1)
                                    {
                                                   var filteredEvents: [String] = self.getdifferentSeasonArray.value(forKeyPath: "@distinctUnionOfObjects.season_label") as! [String]
                                            filteredEvents.sort()
                                            self.commonArray.append(contentsOf: filteredEvents)
                                    }
                                    else
                                    {
                                    var filteredEvents: [String] = self.getSameSeasonArray.value(forKeyPath: "@distinctUnionOfObjects.season_label") as! [String]
                                                                            filteredEvents.sort()
                                            self.commonArray.append(contentsOf: filteredEvents)
                                    }
                                    
                                 }
                          else if (self.getSameSportsArray.count > 0)
                          {
                            self.addorderArray.add(commonArray.last!)

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
                self.addorderArray.add(commonArray.last!)

                   self.commonArray = NSMutableArray() as? [String]
                   for i in 0..<getdifferentSeasonArray.count
                   {
                       let roleDic: NSDictionary = getdifferentSeasonArray?[i] as! NSDictionary
                       let role: String = roleDic.value(forKey: "season_id") as! String
                       if(role == getSeasonid)
                       {
                           self.getLevel = roleDic.value(forKey: "level_name") as? String
                           getSameLevelArray.add(roleDic)
                           getLevelid = roleDic.value(forKey: "level_id") as? String

                       }
                       else
                       {
                           getdifferentLevelArray.add(roleDic)
                       }

                   }
                if(getdifferentLevelArray.count > 1)
                {
                      var filteredEvents: [String] = self.getdifferentLevelArray.value(forKeyPath: "@distinctUnionOfObjects.level_name") as! [String]
                                    filteredEvents.sort()
                                        self.commonArray.append(contentsOf: filteredEvents)
                }
                else
                {
                      var filteredEvents: [String] = self.getSameLevelArray.value(forKeyPath: "@distinctUnionOfObjects.level_name") as! [String]
                                       filteredEvents.sort()
                                          self.commonArray.append(contentsOf: filteredEvents)
                }
               }
               else if(getSameSeasonArray.count>0)
               {
                self.addorderArray.add(commonArray.last!)

                   self.commonArray = NSMutableArray() as? [String]
                      // self.addorderArray.add("\(getSeason!)")
                       for i in 0..<getSameSeasonArray.count
                       {
                           let roleDic: NSDictionary = getSameSeasonArray?[i] as! NSDictionary
                           let role: String = roleDic.value(forKey: "season_id") as! String
                           if(role == getSeasonid)
                           {
                               self.getLevel = roleDic.value(forKey: "level_name") as? String
                               getSameLevelArray.add(roleDic)
                               getLevelid = roleDic.value(forKey: "level_id") as? String

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
                            self.addorderArray.add(commonArray.last!)

                            self.commonArray = NSMutableArray() as? [String]

                            for i in 0..<getdifferentLevelArray.count
                            {
                                let roleDic: NSDictionary = getSameSeasonArray?[i] as! NSDictionary
                                let role: String = roleDic.value(forKey: "level_id") as! String
                                if(role == getLevelid)
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
                            if(getdifferentTeamArray.count > 1)
                            {
                                 var filteredEvents: [String] = self.getdifferentTeamArray.value(forKeyPath: "@distinctUnionOfObjects.team_name") as! [String]
                                                        filteredEvents.sort()
                            
                                                self.commonArray.append(contentsOf: filteredEvents)
                            }
                            else
                            {
                                 var filteredEvents: [String] = self.getSameTeamArray.value(forKeyPath: "@distinctUnionOfObjects.team_name") as! [String]
                                                        filteredEvents.sort()
                                
                                self.commonArray.append(contentsOf: filteredEvents)
                            }
                            

//


                        }
                else if(getSameLevelArray.count > 0)
                 {
                    self.addorderArray.add(commonArray.last!)

                    self.commonArray = NSMutableArray() as? [String]
//                    self.addorderArray.add("\(getLevel!)")
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

                                              }
                                          }
    
    func feedCount(selectArray: NSMutableArray)
    {

        let feedlevelobjsArray: NSMutableArray = NSMutableArray()

        if(selectArray.count > 0)
        {

            for i in 0..<selectArray.count
            {
                let feedlevelobj : NSMutableDictionary = NSMutableDictionary()
                let teamDic = selectArray[i]
                if(addorderArray.count == 1)
                {
                feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)", forKey: "feedLevel")
                feedlevelobjsArray.add(feedlevelobj)

                }
                else if(addorderArray.count == 2)
                {
                  feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                  feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                    
                 feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)", forKey: "feedLevel")
                }
                else if(addorderArray.count == 3)
                {
                    feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                     feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                    
                    feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")

                    
                    feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)", forKey: "feedLevel")
                }
                else if(addorderArray.count == 4)
                {
                    feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                     feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                    
                    feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")
                    
                    feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "level_id"), forKey: "level_id")

                    
                    feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "level_id")!)", forKey: "feedLevel")
                }
                else if(addorderArray.count == 5)
                {
                   feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                     feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                    
                    feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")
                    
                    feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "level_id"), forKey: "level_id")
                    
                    feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "team_id"), forKey: "team_id")

                    
                    feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "level_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "team_id")!)" , forKey: "feedLevel")
                }
                feedlevelobjsArray.add(feedlevelobj)

            }
        }
       
        
        getcount(feedlevelobj: feedlevelobjsArray.copy() as! NSArray)
       
    }
    
    func getcount(feedlevelobj: NSArray)
    {
        Constant.internetconnection(vc: self)
           Constant.showActivityIndicatory(uiView: self.view)
               let testStatusUrl: String = Constant.sharedinstance.FeedCountUrl
        let header: HTTPHeaders = [
            "idtoken": UserDefaults.standard.string(forKey: "idtoken") ?? ""]
                var param:[String:AnyObject] = [:]
               param["user_id"] = UserDefaults.standard.string(forKey: "UUID") as AnyObject?
        
        param["feededLevelObject"] = feedlevelobj as AnyObject

        AF.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON{ (response) in
            Constant.showInActivityIndicatory()

                   if(!(response.error != nil)){
                       switch (response.result)
                       {
                       case .success(let json):
                        let jsonData = json

                       // if let data = response.data{
                               let info = jsonData as? NSDictionary
                               let statusCode = info?["status"] as? Bool
                               let message = info?["message"] as? String

                               if(statusCode == true)
                               {
                                   let result = info?["data"] as! NSArray
                                   self.countArray = NSMutableArray()
                                   self.countArray = result.mutableCopy() as? NSMutableArray
                                    Constant.showInActivityIndicatory()
                                   self.feed_selector_tbl.reloadData()
                               }
                               else
                               {
                                   if(message == "unauthorized user")
                                   {
                                    if #available(iOS 13.0, *) {
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        appDelegate.timerAction()

                                    } else {
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        appDelegate.timerAction()
                                    }
                                       //self.getplayerlist()
                                   }
                                else
                                {
                                    Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "\(message!)")

                                }
                                  Constant.showInActivityIndicatory()

                               }
                          // }
                           break

                       case .failure(_):
                           Constant.showInActivityIndicatory()

                           break
                       }
                   }
                   else
                   {
                       //Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: "\(Constant.sharedinstance.errormsgDetail)")
                       Constant.showInActivityIndicatory()

                   }
               }
    }
           
        @objc func orderselectmethod(_ sender: UIButton)
           {
               let selecttag = sender.tag
              // orderviewheight.constant = 50

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
                   getuserDetail()

               }
               else if(selecttag == 3)
               {
                   print("season")
                self.addorderArray = NSMutableArray()
                getorganization()
                getsportsmethod()
                getSeasonmethod()
                getLevelmethod()
                getuserDetail()
               }
               else if(selecttag == 4)
               {
                print("level")
                 self.addorderArray = NSMutableArray()
                 getorganization()
                 getsportsmethod()
                 getSeasonmethod()
                 getLevelmethod()
                getTeammethod()
                 getuserDetail()
               }
            else if(selecttag == 5)
               {
                print("team")
                   self.addorderArray = NSMutableArray()
                    getorganization()
                    getsportsmethod()
                    getSeasonmethod()
                    getLevelmethod()
                   getTeammethod()
                self.addorderArray.add("\(getTeamId!)")
                    usergroup()
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
                    
            let cell: FeedSelectorCell = tableView.dequeueReusableCell(withIdentifier: "feedselector", for: indexPath) as! FeedSelectorCell

               
            cell.feed_name_Btn.setTitleColor(UIColor.black, for: .normal)
            cell.feed_name_Btn.setTitle(self.commonArray[indexPath.row], for: .normal)
          
           let name = self.commonArray[indexPath.row]
            let size = (name as NSString).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
            print("size\(size)")
                       if((getRole == "coach" || getRole == "manager"))
                      {
                        if(self.addorderArray.count < 6)
                        {
                            if(self.countArray.count>0)
                            {
                            let countDic: NSDictionary = self.countArray?[indexPath.row] as! NSDictionary
                            let count: Int = countDic.value(forKey: "count") as! Int
                            cell.feed_count_Btn.frame = CGRect(x: size.width + 20, y: 10, width: 50, height: 25)
                            cell.feed_count_Btn.setTitle("\(count)", for: .normal)
                            cell.feed_count_Btn.isHidden  = false
                            cell.feed_count_Btn.layer.cornerRadius = 0
                            cell.feed_count_Btn.layer.borderWidth = 0.5
                            cell.feed_count_Btn.layer.borderColor = UIColor.gray.cgColor
                            cell.feed_count_Btn.layer.masksToBounds = true
                           cell.feed_img_Btn.frame = CGRect(x: size.width + 75, y: 10, width: 25, height: 25)
                            cell.feed_img_Btn.addTarget(self, action: #selector(PersonIcon), for: .touchUpInside)
                            cell.feed_img_Btn.isHidden  = false
                            cell.feed_img_Btn.setImage(UIImage(named: "user"), for: .normal)
                            cell.feed_img_Btn.tintColor = UIColor.black
                            
                            }

                        }
                        else
                        {
                            cell.feed_count_Btn.setImage(nil, for: .normal)
                            cell.feed_count_Btn.isHidden  = true
                            cell.feed_img_Btn.isHidden = true

                       }
                       }
                      else
                      {
                        if(countArray.count>0)
                         {
                         let countDic: NSDictionary = self.countArray?[indexPath.row] as! NSDictionary
                         let count: Int = countDic.value(forKey: "count") as! Int
                         cell.feed_count_Btn.frame = CGRect(x: size.width + 15, y: 10, width: 50, height: 25)
                         cell.feed_count_Btn.setTitle("\(count)", for: .normal)
                         cell.feed_count_Btn.isHidden  = false
                         cell.feed_count_Btn.layer.cornerRadius = 0
                         cell.feed_count_Btn.layer.borderWidth = 0.5
                         cell.feed_count_Btn.layer.borderColor = UIColor.gray.cgColor
                         cell.feed_count_Btn.layer.masksToBounds = true
                         cell.feed_img_Btn.frame = CGRect(x: size.width + 70, y: 10, width: 25, height: 25)
                         cell.feed_img_Btn.addTarget(self, action: #selector(PersonIcon), for: .touchUpInside)
                         cell.feed_img_Btn.isHidden  = false
                         cell.feed_img_Btn.setImage(UIImage(named: "user"), for: .normal)
                         cell.feed_img_Btn.tintColor = UIColor.black

                         
                         }

                       }
                        cell.feed_name_Btn.tag = indexPath.row
                        cell.feed_img_Btn.tag = indexPath.row
                        cell.feed_name_Btn.setTitleColor(UIColor.blue, for: .normal)
                       cell.feed_name_Btn.addTarget(self, action: #selector(SelectTeamName), for: .touchUpInside)
                        cell.selectionStyle = .none
                        cell.accessoryType = (addorderArray.count == 7) ? .none : .disclosureIndicator
                    return cell
                    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                  print("You tapped cell number \(indexPath.row).")
        if(self.addorderArray.count < 5)
        {
        self.addorderArray = NSMutableArray()
        getorganization()
        getsportsmethod()
        getSeasonmethod()
        getLevelmethod()
        getTeammethod()
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
                let role: String = "\(roleDic.value(forKey: "first_name") as! String)" + " " + "\(roleDic.value(forKey: "last_name")!)"
                var filteredEvents: [String] = [role]
                 filteredEvents.sort()
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
            if((getRole == "coach" || getRole == "manager") && addorderArray.count>3)
            {
               peopleArray = ["Coaches", "Guardians", "Players", "Managers"]
            }
            else
            {
               peopleArray = ["Administrators", "Coaches", "Evaluators", "Guardians", "Players", "Managers"]
            }
             let vc = storyboard?.instantiateViewController(withIdentifier: "peopleselector") as! PeopleSelectorVC
            vc.delegate = self
            self.addorderArray.add("\(self.commonArray[selectpeople])")
             vc.orderArray = addorderArray
             vc.peoplegrouplist = peopleArray
            vc.auth_UID  = UserDefaults.standard.string(forKey: "UUID")
            vc.role = UserDefaults.standard.string(forKey: "Role")
            vc.organization_id = getOrganization
            vc.sport_id = getSport
            vc.season_id = getSeasonid
            vc.level_id = getLevelid
            vc.toWay = "feedSelector"

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
            docRef.collection("roles_by_season").whereField("role", isEqualTo: self.getRole!).getDocuments() { (querySnapshot, err) in
                Constant.showInActivityIndicatory()

                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else {
                    self.getRolebyreasonDetailArray = NSMutableArray()
                    Constant.showInActivityIndicatory()

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
                        self.getsportsmethod()
                        self.getSeasonmethod()
                        self.getLevelmethod()
                        self.getTeammethod()
                        self.getuserDetail()
                    }

                }
                }

        }
      
        
        @objc func SelectTeamName(_ sender: UIButton)
        {
            let button = sender.tag
            let getTeam: String = self.commonArray[button]
            print(getTeam)
            let selectTeamDetail: NSMutableArray = NSMutableArray()

            if(self.addorderArray.count < 8)
            {
                if(addorderArray.count == 1)
                {
                  print("1")
                if(getdifferentOrganization.count > 1)
                {
                    let dic: NSDictionary = self.getdifferentOrganization?[button] as! NSDictionary

                    selectTeamDetail.add(dic)
                }
                else
                {
                    let dic: NSDictionary = self.getSameOrganization?[button] as! NSDictionary

                    selectTeamDetail.add(dic)
                    
                 }
                }
                else if(addorderArray.count == 2)
                {
                    print("2")
                   if(getdifferentSportsArray.count > 1)
                    {
                        let dic: NSDictionary = self.getdifferentSportsArray?[button] as! NSDictionary

                        selectTeamDetail.add(dic)

                    }
                    else
                    {
                        let dic: NSDictionary = self.getSameSportsArray?[button] as! NSDictionary

                        selectTeamDetail.add(dic)
                    
                    }

                }
                else if(self.addorderArray.count == 3)
                {
                    if(getdifferentSeasonArray.count > 1)
                    {
                        let dic: NSDictionary = self.getdifferentSeasonArray?[button] as! NSDictionary

                        selectTeamDetail.add(dic)
                    }
                    else
                    {
                        let dic: NSDictionary = self.getSameSeasonArray?[button] as! NSDictionary

                        selectTeamDetail.add(dic)
                    
                    }

                }
                else if(addorderArray.count == 4)
                {
                    print("4")
                    if(getdifferentLevelArray.count > 1)
                    {
                        let dic: NSDictionary = self.getdifferentLevelArray?[button] as! NSDictionary

                        selectTeamDetail.add(dic)
                    }
                    else
                    {
                        let dic: NSDictionary = self.getSameLevelArray?[button] as! NSDictionary

                        selectTeamDetail.add(dic)
                    
                    }
                }
                else if(addorderArray.count == 5)
                {
                    if(getdifferentTeamArray.count > 1)
                    {
                        let dic: NSDictionary = self.getdifferentTeamArray?[button] as! NSDictionary
                        selectTeamDetail.add(dic)
                    }
                    else
                    {
                        if(self.getSameTeamArray.count>0)
                        {
                        let dic: NSDictionary = self.getSameTeamArray?[button] as! NSDictionary

                        selectTeamDetail.add(dic)
                        }
                        else{
                            let dic: NSDictionary = self.getdifferentTeamArray?[button] as! NSDictionary

                                selectTeamDetail.add(dic)
                        }
                                       
                    }
                }
                else if(addorderArray.count == 6)
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
                else if(addorderArray.count == 7)
                {
                     for i in 0..<self.GroupList.count
                    {
                    let dic: NSDictionary = GroupList?[i] as! NSDictionary
                    let slectplayer: NSArray = dic.value(forKey: "user_list") as! NSArray
                    for i in 0..<slectplayer.count
                    {
                        let roleDic: NSDictionary = slectplayer[i] as! NSDictionary
                                            let role: String = "\(roleDic.value(forKey: "first_name") as! String)" + " " + "\(roleDic.value(forKey: "last_name")!)"
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
                    }
                }
                                        
            }
            selectmethod(selectitem: selectTeamDetail, selectitemname: getTeam)


        }
    
    func selectmethod(selectitem: NSMutableArray, selectitemname: String)
    {
        let feedlevelobjsArray: NSMutableArray = NSMutableArray()

               if(selectitem.count > 0)
               {

                   for i in 0..<selectitem.count
                   {
                       let feedlevelobj : NSMutableDictionary = NSMutableDictionary()
                       let teamDic = selectitem[i]
                       if(addorderArray.count == 1)
                       {
                       feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                       feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)", forKey: "feedLevel")
                       feedlevelobjsArray.add(feedlevelobj)

                       }
                       else if(addorderArray.count == 2)
                       {
                         feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                         feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                           
                        feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)", forKey: "feedLevel")
                       }
                       else if(addorderArray.count == 3)
                       {
                           feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                            feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                           
                           feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")

                           
                           feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)", forKey: "feedLevel")
                       }
                       else if(addorderArray.count == 4)
                       {
                           feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                            feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                           
                           feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")
                           
                           feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "level_id"), forKey: "level_id")

                           
                           feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "level_id")!)", forKey: "feedLevel")
                       }
                       else if(self.addorderArray.count == 5)
                       {
                          feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "organization_id"), forKey: "organization_id")
                            feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "sport_id"), forKey: "sport_id")
                           
                           feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "season_id"), forKey: "season_id")
                           
                           feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "level_id"), forKey: "level_id")
                           
                           feedlevelobj.setValue((teamDic as AnyObject).value(forKey: "team_id"), forKey: "team_id")

                           
                           feedlevelobj.setValue("\((teamDic as AnyObject).value(forKey: "organization_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "sport_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "season_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "level_id")!)" + "|" + "\((teamDic as AnyObject).value(forKey: "team_id")!)" , forKey: "feedLevel")
                       }
                       feedlevelobjsArray.add(feedlevelobj)

                   }
                
                
               }
              
        if(feedlevelobjsArray.count > 0)
        {
                self.delegate?.feddSelectDetail(userDetail: feedlevelobjsArray, selectitemname: selectitemname)

        }
        else
        {
            Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "Coach Can Select Team or Above As Tag")
        }

        self.navigationController?.popViewController(animated: true)


    }
        
    @IBAction func backfeedselectorbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }
    }

