//
//  PostImageVC.swift
//  SportsGravy
//
//  Created by CSS on 07/02/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

struct PostGroupSection {
    let title: String
    let userlist: NSDictionary
}

class PostImageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postteam_tbl: UITableView!
    @IBOutlet weak var post_content_txt: UITextField!
    @IBOutlet weak var postimage: UIImageView!
    @IBOutlet weak var postvideo: UIImageView!
    var postsections = [PostGroupSection]()
    
    var teamList = [String: String]()
    var tagList = [String: String]()
    var reactionList = [String: String]()
    var canresponseList = [String: String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postteam_tbl.delegate = self
        postteam_tbl.dataSource = self
        
        let addHeader: [String] = ["Who would you like to share this post with?", "How would you like to tag this post?","What was your reaction?","Select a canned response"]

        
        for i in 0..<addHeader.count
        {
            if(i==0)
            {
                self.postsections.append(PostGroupSection(title:"\(addHeader[i])", userlist: teamList as NSDictionary))
            }
            else if(i==1)
            {
                self.postsections.append(PostGroupSection(title:"\(addHeader[i])", userlist: tagList as NSDictionary))

            }
            else if(i == 2)
            {
                self.postsections.append(PostGroupSection(title:"\(addHeader[i])", userlist: reactionList as NSDictionary))

            }
            else if(i==3)
            {
                self.postsections.append(PostGroupSection(title:"\(addHeader[i])", userlist: canresponseList as NSDictionary))

            }
        }
        
       
    }
     // MARK: - UITableViewDataSource

        func numberOfSections(in tableView: UITableView) -> Int {
            return postsections.count
        }
        func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
            return postsections[section].userlist.count
        }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostImageDetailCell  = tableView.dequeueReusableCell(withIdentifier: "postDetail", for: indexPath) as! PostImageDetailCell
          let section = postsections[indexPath.section]
        let dic: NSDictionary = section.userlist[indexPath.row] as! NSDictionary
        cell.detail_btn.setTitle("dfdsd*", for: .normal)
        
      //  if(isCreate == false)
//        {
//        let userSelectArray: NSMutableArray = updateArray.value(forKey: "user_list") as! NSMutableArray
//        for i in 0..<userSelectArray.count
//        {
//            let dics: NSMutableDictionary = userSelectArray[i] as! NSMutableDictionary
//            if(dics.value(forKey: "user_id") as! String == dic.value(forKey: "user_id") as! String)
//            {
//                cell.checkbox.backgroundColor =  UIColor.green
//                self.selectpersonArray.append(dics)
//
//            }
//        }
//        }
       return cell
       }

       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 40.0
       }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return UITableViewAutomaticDimension
        }

        func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
            return 40.0
        }
    
    
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = tableView.dequeueReusableCell(withIdentifier: "postheader") as? PostimageHeaderCell
            let sections = postsections[section].title
            header?.name_lbl.text = "\(sections)"
            header?.add_btn.layer.cornerRadius = 2
            header?.add_btn.layer.borderWidth = 1
            header?.add_btn.layer.borderColor = UIColor.white.cgColor
            header?.add_btn.tag = section
            header?.add_btn.addTarget(self, action: #selector(directview), for: .touchUpInside)
        let sepFrame: CGRect = CGRect(x: 0, y: (header?.frame.size.height)!-1, width: self.view.frame.size.width, height: 1);
            let seperatorView = UIView.init(frame: sepFrame)
            seperatorView.backgroundColor = UIColor.init(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        header?.addSubview(seperatorView)
            return header?.contentView
        }
   
        func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return false
        }

        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
            return .none
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            print("You tapped cell number \(indexPath.section).")
            let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example

            let currentCell = tableView.cellForRow(at: indexPath!) as! UsergroupCreateCell

            if(currentCell.isSelected)
            {
                currentCell.checkbox.backgroundColor = UIColor.green

            }
            else
            {
                currentCell.checkbox.backgroundColor = UIColor.clear
               
            }

        }
        
    @objc func directview(_ sender: UIButton)
    {
        let button = sender.tag
        print(button)
        if(button == 0)
        {
          let objPosttag: PostUsergroupVC = (self.storyboard?.instantiateViewController(identifier: "postuser"))!
            self.navigationController?.pushViewController(objPosttag, animated: true)
        }
        else if(button == 1)
        {
            let objPosttag: PostTagVC = (self.storyboard?.instantiateViewController(identifier: "posttag"))!
            self.navigationController?.pushViewController(objPosttag, animated: true)
        }
        else if(button == 2)
        {
            let objReaction: ReactionVC = (self.storyboard?.instantiateViewController(identifier:"reactionvc"))!
            self.navigationController?.pushViewController(objReaction, animated: true)
            
        }
        else if(button == 3)
        {
            
        }
    }
    @IBAction func backpostbtn(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
