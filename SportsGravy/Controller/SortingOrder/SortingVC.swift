//
//  SortingVC.swift
//  SportsGravy
//
//  Created by CSS on 28/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Alamofire

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

    override func viewDidLoad() {
        super.viewDidLoad()
        sorting_tbl.delegate = self
        sorting_tbl.dataSource = self
        sorting_tbl.tableFooterView = UIView()

        self.sorting_tbl.isEditing = true
        Title_lbl.text = "Sort \(selectType!)"
        getuserDetail()

    }
    func getuserDetail()
       {
           self.addOrderView = UIView()
           self.addOrderView.frame = self.SelectorderView.bounds
           for i in 0..<self.getorderArray.count
           {
               let btn_width = (i==0) ? 30 : 70
               
               let frame1 = (i > 3) ? (getorderArray.firstObject != nil) ? CGRect(x: 10, y: 55, width: btn_width, height: 40 ) : CGRect(x: 0 + (i * 75), y: 10, width: btn_width, height: 40 ) : (getorderArray.firstObject != nil) ? CGRect(x: 10 + (i * 75), y: 10, width: btn_width, height: 40 ) : CGRect(x: 0 + (i * 75), y: 10, width: btn_width, height: 40 )
               let button = UIButton(frame: frame1)
               button.setTitle("\(getorderArray[i] as! String)", for: .normal)
               let lastIndex: Int = getorderArray.count-1
               
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
               self.addOrderView.addSubview(button)
               button.addTarget(self, action: #selector(orderselectmethod), for: .touchUpInside)

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
            return 40.0

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
        cell.username_lbl?.text = headline.value(forKey: "tag_id") as? String
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
        //cell.detailTextLabel?.text = (headline as AnyObject).text
       // cell.imageView?.image = UIImage(named: (sortingOrderArray as AnyObject).image)

           return cell
       }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
           return .none
       }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
           return false
       }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
           let movedObject = self.sortingOrderArray[sourceIndexPath.row]
        //sortingOrderArray.remove(sourceIndexPath.row)
       // self.sortingOrderArray.insert(movedObject, at: destinationIndexPath.row)
          // debugPrint("\(sourceIndexPath.row) => \(destinationIndexPath.row)")
           // To check for correctness enable: self.tableView.reloadData()
        self.sortingOrderArray.replaceObject(at: destinationIndexPath.row, with: movedObject)
        self.updateArray = self.sortingOrderArray as! [NSDictionary]
       }
    @IBAction func updatesorting(_ sender: UIButton)
    {
        Constant.internetconnection(vc: self)
        //Constant.showActivityIndicatory(uiView: self.view)
        let testStatusUrl: String = Constant.sharedinstance.updateSorting
        let header = [
            "idtoken": UserDefaults.standard.string(forKey: "idtoken")]
         var param:[String:AnyObject] = [:]
        let organization: NSDictionary = self.getorganizationDetails?[0] as! NSDictionary
//        param["organization_id"] = organization.value(forKey: "organization_id") as! String as AnyObject
//        param["sports_id"] = organization.value(forKey: "sport_id") as AnyObject?
//        param["season_id"] = organization.value(forKey: "season_id") as AnyObject?
//        param["team_id"] = organization.value(forKey: "team_id") as AnyObject?
//        param["auth_id"] = UserDefaults.standard.string(forKey: "UUID") as AnyObject?
//        param["roleBySeason_id"] = organization.value(forKey: "role_by_season_id") as AnyObject?
//        param["title"] = selectType as AnyObject?
//        param["updateObj"] = self.updateArray as AnyObject
//        
        
        let parameter: [String: AnyObject] = [
            "organization_id" : organization.value(forKey: "organization_id") as AnyObject,
            "sports_id" : organization.value(forKey: "sport_id") as AnyObject,
            "season_id" : organization.value(forKey: "season_id") as AnyObject,
             "team_id" : organization.value(forKey: "team_id") as AnyObject,
              "auth_id" : UserDefaults.standard.string(forKey: "UUID") as AnyObject,
              "roleBySeason_id" : organization.value(forKey: "role_by_season_id") as AnyObject,
               "title" : selectType as AnyObject,
            "updateObj": self.updateArray as AnyObject]
        
        let urlString = "\(testStatusUrl)"
                   let url = URL.init(string: urlString)
        Alamofire.request(url!, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: header as! HTTPHeaders).responseJSON { response in
                        switch response.result
                       {
                       case .success(let json):
                        let jsonData = json
                           print(jsonData)
                        case .failure(let error): break
                          // self.errorFailer(error: error)
                       }
                   }
        
//        Alamofire.request(., method: "http://myserver.com", parameters: parameters, encoding: .JSON)
//            .responseJSON { request, response, JSON, error in
//                print(response)
//                print(JSON)
//                print(error)
//            }
        
        
        
        
        

//        Alamofire.request(testStatusUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header as? HTTPHeaders).responseJSON{ (response:DataResponse<Any>) in
//            if(!(response.error != nil)){
//                switch (response.result)
//                {
//                case .success(_):
//                    if let data = response.result.value{
//                        let info = data as? NSDictionary
//                        let statusCode = info?["status"] as? Bool
//                        //let message = info?["message"] as? String
//
//                        if(statusCode == true)
//                        {
//                            let result = info?["data"] as! NSArray
//
//                           // self.playerListArray = NSMutableArray()
//                            //self.playerListArray = result.mutableCopy() as? NSMutableArray
//                           // self.getGuardians()
//
//                        }
//                        else
//                        {
//                           // Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: message ?? response.result.error as! String)
//                        }
//                       // Constant.showInActivityIndicatory()
//                    }
//                    break
//
//                case .failure(_):
//                    Constant.showInActivityIndicatory()
//
//                    break
//                }
//            }
//            else
//            {
//                //Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: "\(Constant.sharedinstance.errormsgDetail)")
//                Constant.showInActivityIndicatory()
//
//            }
       // }
    }
     @IBAction func Sortingcancelbtn(_ sender: UIButton)
        {
           self.navigationController?.popViewController(animated: true)
        }
}
