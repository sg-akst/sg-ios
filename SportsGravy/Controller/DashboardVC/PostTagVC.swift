//
//  PostTagVC.swift
//  SportsGravy
//
//  Created by CSS on 14/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

protocol SelectPostTagDelegate: AnyObject {
    func selectPostTagDetail(userDetail: NSDictionary)

}

class PostTagVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var posttag_tbl: UITableView!
    var TeamId: String!
    
    var taglist: NSMutableArray!
    weak var delegate:SelectPostTagDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        taglist = NSMutableArray()
        self.posttag_tbl.delegate = self
        self.posttag_tbl.dataSource = self
        posttag_tbl.tableFooterView = UIView()
        posttag_tbl.sizeToFit()
        getTag()
    
    }
    
    func getTag()
        {
            Constant.internetconnection(vc: self)
                   Constant.showActivityIndicatory(uiView: self.view)
                   let getuuid = UserDefaults.standard.string(forKey: "UUID")
                    let db = Firestore.firestore()
                        let docRef = db.collection("users").document("\(getuuid!)").collection("roles_by_season").document("\(TeamId!)")

            docRef.collection("Tags").getDocuments() { (querySnapshot, err) in
                Constant.showInActivityIndicatory()

                                 if let err = err {
                                     print("Error getting documents: \(err)")
                                 } else {
                                    self.taglist = NSMutableArray()

                                     for document in querySnapshot!.documents {
                                         let data: NSDictionary = document.data() as NSDictionary
                                         
                                        self.taglist.add(data)
                
                                    }
                                   
                                    self.posttag_tbl.reloadData()
                                    Constant.showInActivityIndicatory()

                                }
                            }
            }
           
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       
       public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.taglist.count
       }
       public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50.0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostTagcell", for: indexPath)
           let dic: NSDictionary = self.taglist[indexPath.row] as! NSDictionary
           cell.textLabel?.text = dic.value(forKey: "tag_name") as? String
           return cell
       }
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectPostTagDetail(userDetail: self.taglist?[indexPath.row] as! NSDictionary)
          self.navigationController?.popViewController(animated: true)

       }
    @IBAction func backpostTagbtn(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
