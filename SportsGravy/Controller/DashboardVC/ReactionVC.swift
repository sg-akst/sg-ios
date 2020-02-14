//
//  ReactionVC.swift
//  SportsGravy
//
//  Created by CSS on 14/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class ReactionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var reaction_tbl: UITableView!
    
    var mydic: NSArray = [["reation_title": "Thumbs Up", "reaction_image": "like"],["reation_title" : "Neutral", "reaction_image": "emotion"], ["reation_title" : "Thumbs Down", "reaction_image": "dislike"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
       reaction_tbl.tableFooterView = UIView()
       reaction_tbl.sizeToFit()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mydic.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ReactionCell = tableView.dequeueReusableCell(withIdentifier: "reaction", for: indexPath) as! ReactionCell
        let dic: NSDictionary = self.mydic[indexPath.row] as! NSDictionary
        cell.reaction_title?.text = dic.value(forKey: "reation_title") as? String
        cell.reation_image.image = UIImage(named: dic.value(forKey: "reaction_image") as! String )
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
       
    }
    @IBAction func backpostReactionbtn(_ sender: UIButton)
       {
           self.navigationController?.popViewController(animated: true)
       }
}
