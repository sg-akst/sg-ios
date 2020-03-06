//
//  SortingVC.swift
//  SportsGravy
//
//  Created by CSS on 28/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

protocol SortorderDelegate: AnyObject {
    func sortingOrderTagupdateSuccess()
    func sortingOrderUsergroupupdateSuccess()
    func sortingOrderCannedupdateSuccess()


}


class SortingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sorting_tbl: UITableView!
    @IBOutlet weak var SelectorderView: UIView!
    @IBOutlet weak var Title_lbl: UILabel!


    var sortingOrderArray: NSMutableArray!
    var getorderArray: NSMutableArray!
    var addOrderView: UIView!
    var selectType: String!
    var getorganizationDetails: NSMutableArray!
    var updateArray = [NSDictionary]()
    var rolebySeasonid: NSString!
    var getTeamId: NSString!
    weak var delegate:SortorderDelegate?
    @IBOutlet weak var orderviewheight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        sorting_tbl.delegate = self
        sorting_tbl.dataSource = self
        sorting_tbl.tableFooterView = UIView()

        self.sorting_tbl.isEditing = true
        Title_lbl.text = (selectType == "MemberGroup") ? "Sort User Group" : selectType
        sorting_tbl.sizeToFit()
        getuserDetail()

    }
    func getuserDetail()
    {
        self.orderviewheight.constant = (self.getorderArray.count > 5) ? 90 : 50

            let buttons: NSMutableArray = NSMutableArray()
            var indexOfLeftmostButtonOnCurrentLine: Int = 0
            var runningWidth: CGFloat = 10.0
            let maxWidth: CGFloat = 375.0
            let horizontalSpaceBetweenButtons: CGFloat = 5.0
            let verticalSpaceBetweenButtons: CGFloat = 5.0
            if(self.addOrderView != nil)
            {
               self.addOrderView.removeFromSuperview()
            }
            self.addOrderView = UIView()
            self.addOrderView.frame = self.SelectorderView.bounds
            for i in 0..<self.getorderArray.count
            {
                let addTitle_btn: UIButton = UIButton(type: .roundedRect)
    
                addTitle_btn.titleLabel?.font = UIFont(name: "Arial", size: 18)
                //addTitle_btn.setTitle("\(getorderArray[i] as! String)", for: .normal)
                let title: String = getorderArray?[i] as! String
                if(title != "" && title != nil)
                 {
                 if(i == 0)
                 {
                     addTitle_btn.setTitle("\(getorderArray[i] as! String)", for: .normal)
                 }
                 else
                 {
                   addTitle_btn.setTitle("> \(getorderArray[i] as! String)", for: .normal)

                 }
                }
                
                addTitle_btn.translatesAutoresizingMaskIntoConstraints = false
                let attrStr = NSMutableAttributedString(string: "\(addTitle_btn.title(for: .normal) ?? "")")
                if(i != 0)
                {
                attrStr.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: 1))
                }
                addTitle_btn.setAttributedTitle(attrStr, for: .normal)

                let lastIndex: Int = getorderArray.count-1
               
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
                self.addOrderView.addSubview(addTitle_btn)
                addTitle_btn.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)
                if ((i == 0) || (runningWidth + addTitle_btn.frame.size.width > maxWidth))
                 {
                     runningWidth = addTitle_btn.frame.size.width
                    if(i==0)
                    {
                        // first button (top left)
                        // horizontal position: same as previous leftmost button (on line above)
                       let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .left, relatedBy: .equal, toItem: self.addOrderView, attribute: .left, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                       addTitle_btn.setAttributedTitle(attrStr, for: .normal)
                        addOrderView.addConstraint(horizontalConstraint)
                        
                        // vertical position:
                        let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .top, relatedBy: .equal, toItem: self.addOrderView, attribute: .top, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                        self.addOrderView.addConstraint(verticalConstraint)
                            
                    }
                    else{
                        // put it in new line
                        let previousLeftmostButton: UIButton = buttons.object(at: indexOfLeftmostButtonOnCurrentLine) as! UIButton

                        // horizontal position: same as previous leftmost button (on line above)
                        let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .left, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .left, multiplier: 1.0, constant: 0.0)
                        self.addOrderView.addConstraint(horizontalConstraint)


                        // vertical position:
                        let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .top, relatedBy: .equal, toItem: previousLeftmostButton, attribute: .bottom, multiplier: 1.0, constant: verticalSpaceBetweenButtons)
                        self.addOrderView.addConstraint(verticalConstraint)

                        indexOfLeftmostButtonOnCurrentLine = i
                    }
                }
                else
                {
                    runningWidth += addTitle_btn.frame.size.width + horizontalSpaceBetweenButtons;

                    let previousButton: UIButton = buttons.object(at: i-1) as! UIButton  //[buttons objectAtIndex:(i-1)];

                               // horizontal position: right from previous button
                    let horizontalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .left, relatedBy: .equal, toItem: previousButton, attribute: .right, multiplier: 1.0, constant: horizontalSpaceBetweenButtons)
                    self.addOrderView.addConstraint(horizontalConstraint)
                        
                               // vertical position same as previous button
                    let verticalConstraint: NSLayoutConstraint = NSLayoutConstraint(item: addTitle_btn, attribute: .top, relatedBy: .equal, toItem: previousButton, attribute: .top, multiplier: 1.0, constant: 0.0)
                    self.addOrderView.addConstraint(verticalConstraint)

                }
                buttons.add(addTitle_btn)

                
            }
           
            self.SelectorderView.addSubview(addOrderView)

        }

       @objc func orderselectmethod(_ sender: UIButton)
         {
             self.navigationController?.popViewController(animated: true)
       
         }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return sortingOrderArray.count
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
        if(selectType == "Tags")
        {
            return 55.0

        }
        else
        {
           return 80.0
        
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SortingCell = tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath) as! SortingCell

        let headline: NSDictionary = sortingOrderArray?[indexPath.row] as! NSDictionary
        if(selectType == "Tags")
        {
        cell.username_lbl?.text = headline.value(forKey: "tag_name") as? String
        }
        else if(selectType == "CannedResponse")
        {
            cell.username_lbl?.text = headline.value(forKey: "cannedResponseDesc") as? String
            cell.detail_lbl?.text = headline.value(forKey: "cannedResponseTitle") as? String

        }
        else if(selectType == "MemberGroup")
        {
            cell.username_lbl?.text = headline.value(forKey: "display_name") as? String
            let userArray: NSMutableArray = headline.value(forKey: "user_list") as! NSMutableArray

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
            cell.detail_lbl?.text = "\(filtered)"


        }

           return cell
       }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return .none
       }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
           return false
       }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let item : NSDictionary = sortingOrderArray?[sourceIndexPath.row] as! NSDictionary;
        self.sortingOrderArray.removeObject(at: sourceIndexPath.row)
        self.sortingOrderArray.insert(item, at: destinationIndexPath.row)
        
        
//           let movedObject = self.sortingOrderArray[sourceIndexPath.row]
//        self.sortingOrderArray.remove(sourceIndexPath.row)
//        self.sortingOrderArray.insert(movedObject, at: destinationIndexPath.row)
        for i in 0..<self.sortingOrderArray.count
        {
            let dic: NSMutableDictionary = self.sortingOrderArray?[i] as! NSMutableDictionary
            dic.removeObject(forKey: "updated_datetime")
            dic.removeObject(forKey: "created_datetime")
//            if(self.selectType == "CannedResponse")
//            {
//                dic.removeObject(forKey: "created_datetime")
//
//            }
            self.updateArray.append(dic)
        }
        print("\(self.updateArray)")
       }
    @IBAction func updatesorting(_ sender: UIButton)
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        Constant.internetconnection(vc: self)
        let testStatusUrl: String = Constant.sharedinstance.updateSorting
        let header: HTTPHeaders  = [
            "idtoken": UserDefaults.standard.string(forKey: "idtoken")!]
        let organization: NSDictionary = self.getorganizationDetails?[0] as! NSDictionary
        //let str = ("MemberGroup" == self.selectType) ? "User Group" : self.selectType
        let parameter: [String: Any] = [
            "organization_id" : organization.value(forKey: "organization_id") as! String,
            "sports_id" : organization.value(forKey: "sport_id") as! String,
            "season_id" : organization.value(forKey: "season_id") as! String,
             "team_id" : getTeamId as String,
             "auth_id" : UserDefaults.standard.string(forKey: "UUID")!,
              "roleBySeason_id" : rolebySeasonid as String,
              "title" : selectType!,
               "updateObj": self.updateArray]
        
        let urlString = "\(testStatusUrl)"
        let url = URL.init(string: urlString)
        print("parameter=>\(parameter)")
        
        
        
AF.request(url!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                        switch response.result
                       {
                       case .success(let json):
                        let jsonData = json
                           print(jsonData)
                        let info = jsonData as? NSDictionary
                        let statusCode = info?["status"] as? Bool
                        let message = info?["message"] as? String
                        if(statusCode == true)
                        {
                            let str = ("MemberGroup" == self.selectType) ? "User Group" : self.selectType
                            self.alertermsg(msg: " \(str!) Sorted Successfully ")

                        }
                        else
                        {
                           if(message == "unauthorized user")
                            {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.timerAction()
                                self.updatesorting(sender)
                            }
                        }
                       // Constant.showAlertMessage(vc: self, titleStr: "SportsGravy", messageStr: " \(str!) Sorted Successfully ")
                            
                            
                        case .failure(let error): break
                           //self.errorFailer(error: error)
                       }

                        Constant.showInActivityIndicatory()

                   }

    }
    func alertermsg(msg: String)
         {
             let alert = UIAlertController(title: "SportsGravy", message: msg, preferredStyle: UIAlertController.Style.alert);
             alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                if(self.selectType == "MemberGroup")
                {
                    self.delegate?.sortingOrderUsergroupupdateSuccess()
                }
                else if(self.selectType == "CannedResponse")
                {
                    self.delegate?.sortingOrderCannedupdateSuccess()
                }
                else if(self.selectType == "Tags")
                {
                    self.delegate?.sortingOrderTagupdateSuccess()
                }
                 self.navigationController?.popViewController(animated: false)
                    }))
             
             self.present(alert, animated: true, completion: nil)
             
         }
     
    
     @IBAction func Sortingcancelbtn(_ sender: UIButton)
        {
           self.navigationController?.popViewController(animated: true)
        }
}
