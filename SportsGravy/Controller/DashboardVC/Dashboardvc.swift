//
//  Dashboardvc.swift
//  SportsGravy
//
//  Created by CSS on 07/01/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit
import SWRevealViewController
class Dashboardvc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var post_tbl: UITableView!
    let myArray = ["row 1", "row 2", "row 3", "row 4"]

    override func viewDidLoad() {
        super.viewDidLoad()

                if revealViewController() != nil {
                    revealViewController().rearViewRevealWidth = self.view.frame.size.width - 70
                    view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                    }

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

        if #available(iOS 10.0, *) {
            post_tbl.refreshControl = refreshControl
        } else {
            post_tbl.backgroundView = refreshControl
        }
        self.post_tbl.delegate = self
        self.post_tbl.dataSource = self
    }
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        // Do your job, when done:
        refreshControl.endRefreshing()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return myArray.count
        }

        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            // create a new cell if needed or reuse an old one
            let cell:PostCell = self.post_tbl.dequeueReusableCell(withIdentifier: "post") as! PostCell

            // set the text from the data model
            cell.username_lbl?.text = myArray[indexPath.row]

            return cell
        }

        // method to run when table view cell is tapped
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 450.0
    }
    
    
    @IBAction func menuBtn(_ sender: UIButton)
    {
        self.revealViewController().revealToggle(self)

    }
    
}
