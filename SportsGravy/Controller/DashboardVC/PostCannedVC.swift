//
//  PostCannedVC.swift
//  SportsGravy
//
//  Created by CSS on 14/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

protocol SelectpostCanDelegate: AnyObject {
    func selectPostCanDetail(userDetail: NSDictionary)

}



class PostCannedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postcanned_tbl: UITableView!
    weak var delegate:SelectpostCanDelegate?

    var tagCannedArray: NSMutableArray!
    var TeamId: String!
    var rolebyseasonid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagCannedArray = NSMutableArray()
        self.postcanned_tbl.delegate = self
        self.postcanned_tbl.dataSource = self
        postcanned_tbl.tableFooterView = UIView()
        postcanned_tbl.sizeToFit()
        getCanned()
    }
    
    func getCanned()
    {
        Constant.internetconnection(vc: self)
               Constant.showActivityIndicatory(uiView: self.view)
               let getuuid = UserDefaults.standard.string(forKey: "UUID")
                let db = Firestore.firestore()
                    let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(rolebyseasonid!)")

        if (UserDefaults.standard.bool(forKey: "canned_user") == true) {
                            
                            docRef.collection("CannedResponse").order(by: "count", descending: true).getDocuments() { (querySnapshot, err) in
                                //Constant.showInActivityIndicatory()

                                 if let err = err {
                                     print("Error getting documents: \(err)")
                                 } else {
                                    self.tagCannedArray = NSMutableArray()
        
                                     for document in querySnapshot!.documents {
                                         let data: NSDictionary = document.data() as NSDictionary
                                        self.tagCannedArray.add(data)
        
        
                                    }
                                    
                                    self.postcanned_tbl.reloadData()
                                    Constant.showInActivityIndicatory()
        
                                }
                            }
                }
        else if (UserDefaults.standard.bool(forKey: "canned_team") == true) {
        let docRefteam = db.collection("teams").document("\(TeamId!)")

                            docRefteam.collection("CannedResponse").order(by: "count", descending: true).getDocuments() { (querySnapshot, err) in
                                 if let err = err {
                                     print("Error getting documents: \(err)")
                                 } else {
                                    self.tagCannedArray = NSMutableArray()
        
                                     for document in querySnapshot!.documents {
                                         let data: NSDictionary = document.data() as NSDictionary
                                        self.tagCannedArray.add(data)
        
        
                                    }
                                   
                                    self.postcanned_tbl.reloadData()
                                    Constant.showInActivityIndicatory()
        
                                }
                            }
                }
       else {
                    docRef.collection("CannedResponse").order(by: "updated_datetime", descending: false).getDocuments() { (querySnapshot, err) in
                                            if let err = err {
                                                print("Error getting documents: \(err)")
                                            } else {
                                               self.tagCannedArray = NSMutableArray()
        
                                                for document in querySnapshot!.documents {
                                                    let data: NSDictionary = document.data() as NSDictionary
                                                   self.tagCannedArray.add(data)
        
        
                                               }
                                               
                                               self.postcanned_tbl.reloadData()
                                               Constant.showInActivityIndicatory()
        
                                           }
                                       }
                }
        

        }
       
    
    func numberOfSections(in tableView: UITableView) -> Int {
              return 1
          }
          
          public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return self.tagCannedArray.count
          }
          public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return 70.0
          }
          
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: PostCanCell = tableView.dequeueReusableCell(withIdentifier: "postcancell", for: indexPath) as! PostCanCell
              let dic: NSDictionary = self.tagCannedArray[indexPath.row] as! NSDictionary
              cell.can_title_lbl?.text = dic.value(forKey: "cannedResponseTitle") as? String
            cell.can_title_lbl.textColor = UIColor.blue
            cell.can_desc_lbl?.text = dic.value(forKey: "cannedResponseDesc") as? String
              return cell
          }
          func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
            self.delegate?.selectPostCanDetail(userDetail: self.tagCannedArray?[indexPath.row] as! NSDictionary)
            self.navigationController?.popViewController(animated: true)
            
             
          }
    @IBAction func backpostCannedbtn(_ sender: UIButton)
       {
           self.navigationController?.popViewController(animated: true)
       }

}
