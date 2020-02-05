//
//  SittingsVC.swift
//  SportsGravy
//
//  Created by CSS on 27/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class SittingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var sitting_tbl: UITableView!

    var sittingslistArray: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sitting_tbl.delegate = self
        sitting_tbl.dataSource = self
        sittingslistArray = NSMutableArray()
        let titleArray  = ["Feed Post", "User Groups", "Tags", "Canned Responses"]
        let subTitle   = ["Enable Posting Feed When WIFI is Connected","Enable Custom Sort ordering","Enable Custom Sort ordering","Enable Custom Sort ordering"]
        for i in 0..<titleArray.count
        {
            let createList: NSMutableDictionary = NSMutableDictionary()
            createList.setValue(titleArray[i], forKey: "title")
            createList.setValue(subTitle[i], forKey: "subTitle")
            sittingslistArray.add(createList)
        }
        sitting_tbl.tableFooterView = UIView()


    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.sittingslistArray.count
    
            }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    
           return 69.0

     }

            // create a cell for each table view row
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell: SittingCell = self.sitting_tbl.dequeueReusableCell(withIdentifier: "sittingCell") as! SittingCell
    let dic: NSDictionary = sittingslistArray?[indexPath.row] as! NSDictionary
    cell.segment_btn.tag = indexPath.row
    cell.title_lbl?.text = dic.value(forKey: "title") as? String
    cell.subtitle_lbl.text = dic.value(forKey: "subTitle") as? String
    //cell.segment_btn.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
    cell.segment_btn.tag = indexPath.row
    if(UserDefaults.standard.integer(forKey: ("\(indexPath.row)")) == indexPath.row)
    {
        print("check bool \(UserDefaults.standard.integer(forKey: ("\(indexPath.row)")))")
        if((UserDefaults.standard.integer(forKey: ("\(indexPath.row)"))) == 1)
        {
            cell.segment_btn.isOn = true
        }
        else
        {
            cell.segment_btn.isOn = false
        }
        
    }
    else{
        print("check bool \(UserDefaults.standard.integer(forKey: ("\(indexPath.row)")))")
        if((UserDefaults.standard.integer(forKey: ("\(indexPath.row)"))) == 1)
               {
                   cell.segment_btn.isOn = true

               }
               else
               {
                   cell.segment_btn.isOn = false

               }

    }
    return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
       
        
    }
    @objc func switchValueDidChange(_ sender: UISwitch){
       let button = sender
    let cell = button.superview?.superview as? SittingCell
             //let indexPaths = sitting_tbl.indexPath(for: cell!)
      // let dicvalu = sittingslistArray![indexPaths!.row]
            // print(dicvalu)
        if sender.isOn {
           cell?.segment_btn.isOn =  true
            if(button.tag == 0)
            {
                UserDefaults.standard.set(true, forKey: "\(button.tag)")
            }
            if(button.tag == 1)
            {
                UserDefaults.standard.set(true, forKey: "\(button.tag)")
            }
            if(button.tag == 2)
            {
                UserDefaults.standard.set(true, forKey: "\(button.tag)")
            }
            if(button.tag == 3)
            {
                UserDefaults.standard.set(true, forKey: "\(button.tag)")
            }
          } else {

              cell?.segment_btn.isOn =  false
           if(button.tag == 0)
           {
               UserDefaults.standard.set(false, forKey: "\(button.tag)")
           }
           if(button.tag == 1)
           {
               UserDefaults.standard.set(false, forKey: "\(button.tag)")
           }
           if(button.tag == 2)
           {
               UserDefaults.standard.set(false, forKey: "\(button.tag)")
           }
           if(button.tag == 3)
           {
               UserDefaults.standard.set(false, forKey: "\(button.tag)")
           }
          }

      }
@IBAction func settingcancelbtn(_ sender: UIButton)
{
    self.navigationController?.popViewController(animated: true)
}
}
