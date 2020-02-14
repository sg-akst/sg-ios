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

class PostUsergroupVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var postusergroup_tbl: UITableView!
       var postGroupArray: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       postGroupArray = NSMutableArray()
        postusergroup_tbl.tableFooterView = UIView()
        postusergroup_tbl.sizeToFit()
        getusergroup()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
                 return 1
             }
             
             public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                 return self.postGroupArray.count
             }
             public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                 return 50.0
             }
             
             func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "postusercell", for: indexPath)
                 let dic: NSDictionary = self.postGroupArray[indexPath.row] as! NSDictionary
                 cell.textLabel?.text = dic.value(forKey: "reation_title") as? String
                 return cell
             }
             func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              
                
             }
    func getusergroup()
    {
        Constant.internetconnection(vc: self)
        Constant.showActivityIndicatory(uiView: self.view)
        let getuuid = UserDefaults.standard.string(forKey: "UUID")
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(getuuid!)")
        docRef.collection("roles_by_season").getDocuments() { (querySnapshot, err) in
                                 if let err = err {
                                     print("Error getting documents: \(err)")
                                 } else {
                                    self.postGroupArray = NSMutableArray()

                                     for document in querySnapshot!.documents {
                                         let data: NSDictionary = document.data() as NSDictionary
                                        let getseason_end_date: Timestamp =  data.value(forKey: "season_end_date") as! Timestamp
                                         print("\(document.documentID) => \(getseason_end_date)")
                                        let date: Date = getseason_end_date.dateValue()

                                        if(date > NSDate() as Date)
                                        {
                                            print("yes")
                                        }
                                        self.postGroupArray.add(data)
                                        
                
                                    }
                                    
//                                    self.isTeam = true
//                                    self.createGroupView.isHidden = false
                                    self.postusergroup_tbl.reloadData()
        //                            let indexPath = IndexPath(row: 0, section: 0)
        //                            self.usergroup_tbl.scrollToRow(at: indexPath, at: .top, animated: false)
                                    Constant.showInActivityIndicatory()


                                }
                            }
    }
    
       @IBAction func backpostuserbtn(_ sender: UIButton)
          {
              self.navigationController?.popViewController(animated: true)
          }
}
