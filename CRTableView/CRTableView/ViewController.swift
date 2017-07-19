//
//  ViewController.swift
//  CRTableView
//
//  Created by Kiran Kunigiri on 7/13/17.
//  Copyright © 2017 Kiran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var commentList: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        let c1 = Comment()
        let c2 = Reply()
        let c3 = Comment()
        let c4 = Comment()
        let c5 = Reply()
        commentList = [c1, c2, c3, c4, c5]
        
        // Setup autoresizing
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        let r1 = Reply()
        let r2 = Reply()
        let r3 = Reply()
        commentList.insert(r1, at: 1)
        commentList.insert(r2, at: 1)
        commentList.insert(r3, at: 1)
        self.tableView.reloadData()
        self.tableView.setNeedsLayout()
    }
    
}



extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        
        let comment = commentList[indexPath.row]
        if comment is Reply {
            cell.contentView.layoutMargins = UIEdgeInsetsMake(0, 100, 0, 0)
            cell.viewButton.removeFromSuperview()
        } else {
            cell.contentView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
}



class Comment {
    
}

class Reply: Comment {
    
}

class CommentCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var viewButton: UIButton!
    
    @IBAction func viewButtonTapped(_ sender: UIButton) {
        
    }
}





