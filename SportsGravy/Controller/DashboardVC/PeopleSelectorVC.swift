//
//  PeopleSelectorVC.swift
//  SportsGravy
//
//  Created by CSS on 03/03/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Alamofire
import SWRevealViewController

protocol PeopleSelectorDelegate: AnyObject {
    func passorderArray(select:NSMutableArray!, selectindex: UIButton)
    func selectPeopleSelectorDetail(userDetail: NSMutableArray)


}

class PeopleSelectorVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var peopleSelectorderView: UIView!
    @IBOutlet var people_selector_tbl: UITableView!
    @IBOutlet weak var empty_img: UIImageView!
    var addOrderView: UIView!
    var orderArray: NSMutableArray!
    var order_btn: UIButton!
    var peoplegrouplist: NSMutableArray!
    var getpeopleselectorArray: NSMutableArray!
    var selectGrouptoPlayerlist: NSMutableArray!
    
    var auth_UID: String!
    var role: String!
    var organization_id: String!
    var sport_id: String!
    var season_id: String!
    var level_id: String!
    var team_id: String!
    var toWay: String!
   // var tag_group: String!
    
    
    
    @IBOutlet weak var orderviewheight: NSLayoutConstraint!
    weak var delegate:PeopleSelectorDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {                            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 70
               view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        people_selector_tbl.delegate = self
        people_selector_tbl.dataSource = self
        people_selector_tbl.tableFooterView = UIView()
        people_selector_tbl.sizeToFit()
        empty_img.isHidden = true
        self.people_selector_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.people_selector_tbl.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
         getuserDetail()
    }
    
    func getuserDetail()
    {

        let buttons: NSMutableArray = NSMutableArray()
        var indexOfLeftmostButtonOnCurrentLine: Int = 0
        var runningWidth: CGFloat = 0.0
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let horizontalSpaceBetweenButtons: CGFloat = 8.0
        let verticalSpaceBetweenButtons: CGFloat = 1.5
        if(self.addOrderView != nil)
        {
           self.addOrderView.removeFromSuperview()
        }
        self.addOrderView = UIView()
        self.addOrderView.frame = self.peopleSelectorderView.bounds
        for i in 0..<self.orderArray.count
        {
          order_btn = UIButton(type: .roundedRect)
            order_btn.titleLabel?.font = UIFont(name: "Arial", size: 18)
            order_btn.titleLabel?.textAlignment = .left
         let title: String = orderArray?[i] as! String

         if(title != "" && title != nil)
        {
          if(i == 0)
          {
            order_btn.setTitle("\(orderArray[i] as! String)", for: .normal)
          }
          else
          {
            order_btn.setTitle(" >  \(orderArray[i] as! String)", for: .normal)
          }
            //selectOption_btn.setTitle("\(getorderArray[i] as! String)", for: .normal)
            order_btn.translatesAutoresizingMaskIntoConstraints = false
            let attrStr = NSMutableAttributedString(string: "\(order_btn.title(for: .normal) ?? "")")
            if(i != 0)
            {
                attrStr.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 2))
            }
            order_btn.setAttributedTitle(attrStr, for: .normal)
            let lastIndex: Int = orderArray.count-1
                       
            if(lastIndex == i)
         {
             order_btn.tintColor = UIColor.gray
             order_btn.setTitleColor(UIColor.gray, for: .normal)
             order_btn.isUserInteractionEnabled = false
             }
             else
             {
         order_btn.tintColor = UIColor.blue
         order_btn.setTitleColor(UIColor.blue, for: .normal)
         order_btn.isUserInteractionEnabled = true

         }
            
            order_btn.titleLabel?.textAlignment = .center
            order_btn.sizeToFit()
            order_btn.tag = i
            self.addOrderView.addSubview(order_btn)
            order_btn.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)
             if ((i == 0) || (runningWidth + order_btn.frame.size.width > maxWidth)){
                 runningWidth = order_btn.frame.size.width
                if(i==0)
                {
                    // first button (top left)
                    // horizontal position: same as previous leftmost button (on line above)
                   let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: order_btn, attribute: .left, relatedBy: .equal, toItem: self.addOrderView, attribute: .left, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                   order_btn.setAttributedTitle(attrStr, for: .normal)
                    addOrderView.addConstraint(horizontalConstraint)
                    
                    // vertical position:
                    let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: order_btn, attribute: .top, relatedBy: .equal, toItem: self.addOrderView, attribute: .top, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                    self.addOrderView.addConstraint(verticalConstraint)
                        
                }
                else{
                    // put it in new line
                    let previousLeftmostButton: UIButton = buttons.object(at: indexOfLeftmostButtonOnCurrentLine) as! UIButton

                    // horizontal position: same as previous leftmost button (on line above)
                    let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: order_btn, attribute: .left, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .left, multiplier: 1.0, constant: 0.0)
                    self.addOrderView.addConstraint(horizontalConstraint)


                    // vertical position:
                    let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: order_btn, attribute: .top, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .bottom, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                    self.addOrderView.addConstraint(verticalConstraint)
                    indexOfLeftmostButtonOnCurrentLine = i
                }
            }
            else
            {
                runningWidth += order_btn.frame.size.width + horizontalSpaceBetweenButtons;

                let previousButton: UIButton = buttons.object(at: i-1) as! UIButton
                           
                let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: order_btn, attribute: .left, relatedBy: .equal, toItem: previousButton, attribute: .right, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                self.addOrderView.addConstraint(horizontalConstraint)
                let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: order_btn, attribute: .top, relatedBy: .equal, toItem: previousButton, attribute: .top, multiplier: 1.0, constant: 0.0)
                self.addOrderView.addConstraint(verticalConstraint)
            }
            buttons.add(order_btn)
         }
        }
       
        self.peopleSelectorderView.addSubview(addOrderView)
        self.orderviewheight.constant = 40

        if(indexOfLeftmostButtonOnCurrentLine > 0)
        {
            self.orderviewheight.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 70 : 40
                              
        if(indexOfLeftmostButtonOnCurrentLine > 5)
        {
            self.orderviewheight.constant = (indexOfLeftmostButtonOnCurrentLine > 0) ? 100 : 70
                                      
        }
    }
        if(peoplegrouplist.count > 0)
        {
            people_selector_tbl.reloadData()
        }
    }
    @objc func orderselectmethod(_ sender: UIButton)
    {
        let select = Int (sender.tag - 1)
        let button = UIButton()
        button.tag = select
        self.delegate?.passorderArray(select: self.orderArray,selectindex: button)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.peoplegrouplist.count > 0)
        {
            return self.peoplegrouplist.count
        }
        else
        {
            return self.selectGrouptoPlayerlist.count
        }
           }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                  return 50.0
               
            }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PeopleCell = self.people_selector_tbl.dequeueReusableCell(withIdentifier: "peopel") as! PeopleCell
        if(peoplegrouplist.count > 0)
        {
        cell.people_group_btn?.setTitle("\(peoplegrouplist?[indexPath.row] as! String)", for: .normal)
            cell.accessoryType = .disclosureIndicator

        }
        else
        {
            let dic: NSDictionary  =  self.selectGrouptoPlayerlist?[indexPath.row] as! NSDictionary
            
            cell.people_group_btn?.setTitle("\(dic.value(forKey: "first_name") as! String)" + " " + "\(dic.value(forKey: "last_name") as! String)", for: .normal)
            cell.accessoryType = .none

        }
        cell.people_group_btn?.setTitleColor(UIColor.blue, for: .normal)
        cell.people_group_btn.tag = indexPath.row
        cell.people_group_btn.addTarget(self, action: #selector(selectPeople), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
                
           }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")

        if(peoplegrouplist.count > 0)
        {
        fetchpeopleselector(selectGroup: self.peoplegrouplist?[indexPath.row] as! String)
        self.orderArray.add(self.peoplegrouplist[indexPath.row])
        }
        else
        {
            fetchpeopleselector(selectGroup: self.selectGrouptoPlayerlist?[indexPath.row] as! String)
            self.orderArray.add(self.selectGrouptoPlayerlist[indexPath.row])
        }

    }
    @objc func selectPeople(_ sender: UIButton)
    {
         let getgroup: String!
        let button = sender.tag
        if(peoplegrouplist.count > 0)
        {
            getgroup = self.peoplegrouplist?[button] as? String
        }
        else
        {
            let dic: NSDictionary  =  self.selectGrouptoPlayerlist?[button] as! NSDictionary
                       
            getgroup = "\(dic.value(forKey: "first_name") as! String)" + " " + "\(dic.value(forKey: "last_name") as! String)"

        }
        print(getgroup)
        let selectTeamDetail: NSMutableArray = NSMutableArray()
        
        if(self.orderArray.count == 1)
        {
            
        }
        
       else if(self.orderArray.count == 2)
        {
            
        }
        
       else if(self.orderArray.count == 3)
        {
            
        }
        
       else if(self.orderArray.count == 4)
        {
            
        }
       else if(self.orderArray.count == 5)
        {
            
        }
        else if(self.orderArray.count == 6)
        {
        for i in 0..<self.getpeopleselectorArray.count
        {
            let dic: NSDictionary = getpeopleselectorArray?[i] as! NSDictionary
            if( team_id == dic.value(forKey: "team_id") as? String)
            {
                print(dic)
                let addgroup: NSMutableDictionary = getpeopleselectorArray?[i] as! NSMutableDictionary; addgroup.setValue(getgroup, forKey: "membergroup_id")
                addgroup.setValue(getgroup, forKey: "membergroup_name")
                addgroup.setValue("", forKey: "user_id")
                addgroup.setValue("", forKey: "user_name")
                selectTeamDetail.add(addgroup)
                //selectTeamDetail.add(dic)
            }
        }
        }
        else if(self.orderArray.count > 6)
        {
            for i in 0..<self.getpeopleselectorArray.count
            {
                let dic: NSDictionary = getpeopleselectorArray?[i] as! NSDictionary
                if(team_id == dic.value(forKey: "team_id") as? String)
                {
                    print(dic)
                    let addgroup: NSMutableDictionary = getpeopleselectorArray?[i] as! NSMutableDictionary
                    addgroup.setValue(orderArray.lastObject!, forKey: "membergroup_id")
                    addgroup.setValue(orderArray.lastObject!, forKey: "membergroup_name")
                    addgroup.setValue(getgroup, forKey: "user_id")
                    addgroup.setValue(getgroup, forKey: "user_name")
                    selectTeamDetail.add(addgroup)
                   // selectTeamDetail.add(dic)
                }
            }
        }

        if(selectTeamDetail.count>0)
        {

            if(toWay == "convention")
            {
                let vc = storyboard?.instantiateViewController(withIdentifier: "postimage") as! PostImageVC
                vc.userDetailPeopleselector = selectTeamDetail
               // vc.peopleselector = true
                UserDefaults.standard.set(true, forKey: "peopleselector")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let selectArray: NSMutableArray = NSMutableArray()
                for i in 0..<selectTeamDetail.count
                {
                    let dic: NSMutableDictionary = selectTeamDetail[i] as! NSMutableDictionary
                    dic.removeObject(forKey: "season_start_date")
                    dic.removeObject(forKey: "created_datetime")
                    dic.removeObject(forKey: "season_end_date")
                    selectArray.add(dic)
                }
                
                if #available(iOS 13.0, *) {
                    let swrvc: SWRevealViewController = (self.storyboard?.instantiateViewController(identifier: "revealvc"))!
                    UserDefaults.standard.set(true, forKey: "selectPeople")

                     let defaults = UserDefaults.standard
                     defaults.set(selectArray, forKey: "Team")
                     print(UserDefaults.standard.array(forKey: "Team") as Any)

                    
                     self.navigationController?.pushViewController(swrvc, animated: true)
                } else {
                    let swrvc: SWRevealViewController = (self.storyboard?.instantiateViewController(withIdentifier: "revealvc"))! as! SWRevealViewController
                    UserDefaults.standard.set(true, forKey: "selectPeople")

                     let defaults = UserDefaults.standard
                     defaults.set(selectArray, forKey: "Team")
                     print(UserDefaults.standard.array(forKey: "Team") as Any)

                    
                     self.navigationController?.pushViewController(swrvc, animated: true)
                }
                

        }
        }

    }
    
    func fetchpeopleselector(selectGroup: String)
    {
        
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let testStatusUrl: String = Constant.sharedinstance.getpeopleFetchSelector
        let header: HTTPHeaders = [
            "idtoken": UserDefaults.standard.string(forKey: "idtoken")!]
         var param:[String:AnyObject] = [:]
        param["auth_id"] = auth_UID as AnyObject?
        param["role"] = role as AnyObject?
        param["organization_id"] = organization_id as AnyObject?
        param["sport_id"] = sport_id as AnyObject?
        param["season_id"] = season_id as AnyObject?
        param["level_id"] = level_id as AnyObject?
        param["team_id"] = team_id as AnyObject?
        var selectGroupName: String!
        if(selectGroup == "Coaches")
        {
            selectGroupName = "coach"
        }
        else if(selectGroup == "Guardians")
        {
            selectGroupName = "guardian"
        }
        else if(selectGroup == "Players")
        {
            selectGroupName = "player"
        }
        else if(selectGroup == "Managers")
        {
            selectGroupName = "manager"
        }
        else if(selectGroup == "Administrators")
        {
            selectGroupName = "administrator"
        }
        else if(selectGroup == "Evaluators")
        {
            selectGroupName = "evaluator" 
        }
       
        param["user_group_id"] = selectGroupName as AnyObject?
        print(param)
        AF.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            Constant.showInActivityIndicatory()

            if(!(response.error != nil)){
                switch (response.result)
                {
                case .success(let json):
                   // if let data = response.data{
                        let jsonData = json
                        print(jsonData)
                        let info = jsonData as? NSDictionary
                        let statusCode = info?["status"] as? Bool
                        let message = info?["message"] as? String

                        if(statusCode == true)
                        {
                            let result = info?["data"] as! NSArray
                            self.peoplegrouplist = NSMutableArray()
                            self.selectGrouptoPlayerlist = NSMutableArray()
                            self.selectGrouptoPlayerlist = result.mutableCopy() as? NSMutableArray
                            self.empty_img.isHidden = (self.selectGrouptoPlayerlist.count == 0) ? false : true
                            self.people_selector_tbl.reloadData()
                             Constant.showInActivityIndicatory()
                            if(self.selectGrouptoPlayerlist.count == 0)
                            {
                                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "\(message!)")
                            }
                            else
                            {
                                
                                self.getuserDetail()
                            }
                            Constant.showInActivityIndicatory()

                        }
                        else
                        {
                            if(message == "unauthorized user")
                            {
                                if #available(iOS 13.0, *) {
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.timerAction()
                                    Constant.showInActivityIndicatory()
                                } else {
                                     let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                     appDelegate.timerAction()
                                     Constant.showInActivityIndicatory()
                                }
                               

                            }
                            else
                            {
                                Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: "\(message!)")
                                Constant.showInActivityIndicatory()

                            }
                           
                        }
                        Constant.showInActivityIndicatory()
                  //  }
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
    
    @IBAction func backpeopleselectorbtn(_ sender: UIButton)
    {
       self.navigationController?.popViewController(animated: true)
    }
}
