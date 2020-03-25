//
//  PeopleSelectorVC.swift
//  SportsGravy
//
//  Created by CSS on 03/03/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Alamofire

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
    
    var auth_UID: String!
    var role: String!
    var organization_id: String!
    var sport_id: String!
    var season_id: String!
    var level_id: String!
    var team_id: String!
   // var tag_group: String!
    
    
    
    @IBOutlet weak var orderviewheight: NSLayoutConstraint!
    weak var delegate:PeopleSelectorDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        people_selector_tbl.delegate = self
        people_selector_tbl.dataSource = self
        people_selector_tbl.tableFooterView = UIView()
        people_selector_tbl.sizeToFit()
        empty_img.isHidden = true
        self.people_selector_tbl.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         getuserDetail()
    }
    
    func getuserDetail()
    {
        self.orderviewheight.constant = (self.orderArray.count > 5) ? 90 : 50

        let buttons: NSMutableArray = NSMutableArray()
        var indexOfLeftmostButtonOnCurrentLine: Int = 0
        var runningWidth: CGFloat = 10.0
        let maxWidth: CGFloat = 375.0
        let horizontalSpaceBetweenButtons: CGFloat = 5.0
        let verticalSpaceBetweenButtons: CGFloat = 5.0
        self.addOrderView = UIView()
        self.addOrderView.frame = self.peopleSelectorderView.bounds
        for i in 0..<self.orderArray.count
        {
          order_btn = UIButton(type: .roundedRect)
            order_btn.titleLabel?.font = UIFont(name: "Arial", size: 18)
         let title: String = orderArray?[i] as! String

         if(title != "" && title != nil)
        {
          if(i == 0)
          {
            order_btn.setTitle("\(orderArray[i] as! String)", for: .normal)
          }
          else
          {
            order_btn.setTitle("> \(orderArray[i] as! String)", for: .normal)
          }
            //selectOption_btn.setTitle("\(getorderArray[i] as! String)", for: .normal)
            order_btn.translatesAutoresizingMaskIntoConstraints = false
            let attrStr = NSMutableAttributedString(string: "\(order_btn.title(for: .normal) ?? "")")
            if(i != 0)
            {
                attrStr.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 1))
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
    }
    @objc func orderselectmethod(_ sender: UIButton)
    {
        self.delegate?.passorderArray(select: self.orderArray,selectindex: sender)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              
        return self.peoplegrouplist.count
           }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                  return 50.0
               
            }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PeopleCell = self.people_selector_tbl.dequeueReusableCell(withIdentifier: "peopel") as! PeopleCell
        cell.people_group_btn?.setTitle("\(peoplegrouplist?[indexPath.row] as! String)", for: .normal)
        cell.people_group_btn?.setTitleColor(UIColor.blue, for: .normal)
        cell.people_group_btn.tag = indexPath.row
        cell.people_group_btn.addTarget(self, action: #selector(selectPeople), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
                
           }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        //self.orderArray.add(self.peoplegrouplist[indexPath.row])
        
        getuserDetail()
        fetchpeopleselector(selectGroup: peoplegrouplist?[indexPath.row] as! String)
               
    }
    @objc func selectPeople(_ sender: UIButton)
    {
        let button = sender.tag
        let getgroup: String = self.peoplegrouplist?[button] as! String
        print(getgroup)
        let selectTeamDetail: NSMutableArray = NSMutableArray()
        if(self.orderArray.count == 6)
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
                    addgroup.setValue(dic.value(forKey: "user_groupId"), forKey: "membergroup_id")
                    addgroup.setValue(dic.value(forKey: "user_groupId"), forKey: "membergroup_name")
                    addgroup.setValue("", forKey: "user_id")
                    addgroup.setValue("", forKey: "user_name")
                    selectTeamDetail.add(addgroup)
                   // selectTeamDetail.add(dic)
                }
            }
        }

        self.delegate?.selectPeopleSelectorDetail(userDetail: selectTeamDetail)
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)


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
        param["user_group_id"] = selectGroup as AnyObject?
        
        AF.request(testStatusUrl, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
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
                            self.peoplegrouplist = result.mutableCopy() as? NSMutableArray
                            self.empty_img.isHidden = (self.peoplegrouplist.count == 0) ? false : true

                            self.people_selector_tbl.reloadData()

                           // self.playerListArray = NSMutableArray()
                            //self.playerListArray = result.mutableCopy() as? NSMutableArray
                             Constant.showInActivityIndicatory()
                            
                        }
                        else
                        {
                            if(message == "unauthorized user")
                            {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.timerAction()
                               // self.getplayerlist()
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
