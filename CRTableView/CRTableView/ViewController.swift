//
//  ViewController.swift
//  CRTableView
//
//  Created by Kiran Kunigiri on 7/13/17.
//  Copyright © 2017 Kiran. All rights reserved.
//

import UIKit



// MARK: - Main View Controller
class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        // Setup autoresizing
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        self.tableView.reloadData()
    }
    
}



// MARK: - Table View Data Source
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DM.shared.commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        
        let comment = DM.shared.commentList[indexPath.row]
        cell.setup(comment: comment)
        
        return cell
    }
    
}



// MARK: - Comment Classes
class Comment {
    let objectId = UUID().uuidString
    var isShowingReplies: Bool = false
}

class Reply: Comment {
    
}



// MARK: - Conform to Comment Equatable
extension Comment: Equatable {
    
    // We use an object id so that we can use comparisons and find the index of the comment in the list later
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.objectId == rhs.objectId
    }
    
}



// MARK: - Comment Cell
class CommentCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var viewButton: UIButton!
    @IBOutlet var viewButtonConstraint: NSLayoutConstraint!
    var comment: Comment?
    
    @IBAction func viewButtonTapped(_ sender: UIButton) {
        comment!.isShowingReplies.toggle()

        if !comment!.isShowingReplies {
            // Remove replies
            let indexes = DM.shared.hideReplies(comment: comment!)
            self.tableView?.beginUpdates()
            self.tableView?.deleteRows(at: indexes, with: .automatic)
            self.tableView?.endUpdates()
            
            // Update title
            viewButton.setTitle("View more replies...", for: .normal)
        } else {
            // Load replies
            let indexes = DM.shared.loadReplies(comment: comment!)
            self.tableView?.beginUpdates()
            self.tableView?.insertRows(at: indexes, with: .automatic)
            self.tableView?.endUpdates()
            
            // Update title
            viewButton.setTitle("Hide replies", for: .normal)
        }
    }
    
    func setup(comment: Comment) {
        // Assign comment
        self.comment = comment
        
        // Update UI depending if it is a comment or reply
        if comment is Reply {
            // Inset the comment to the right
            contentView.layoutMargins = UIEdgeInsetsMake(0, 100, 0, 0)
            // Make the label extend to the edges by lowering the button constraint priority and hiding it
            viewButtonConstraint.priority = 997
            viewButton.isHidden = true
        } else {
            // Remove insets
            contentView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
            // Make the label respect the button constraint by making its priority higher and unhiding it
            viewButtonConstraint.priority = 999
            viewButton.isHidden = false
        }
        
        // Update title
        titleLabel.text = comment.objectId
        
        // Update size layout
        self.layoutIfNeeded()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
}



// MARK: - Data Manager
class DM {
    
    /** Singleton instance */
    static let shared = DM()
    
    /** List of all comments, including replies */
    var commentList: [Comment] = []
    
    /** Loads the replies of the corresponding comment into the list */
    func loadReplies(comment: Comment) -> [IndexPath] {
        // Get index of the comment
        let index = commentList.index(of: comment)!
        
        // Generate replies and insert
        let r1 = Reply()
        let r2 = Reply()
        let r3 = Reply()
        commentList.insert(r1, at: index + 1)
        commentList.insert(r2, at: index + 1)
        commentList.insert(r3, at: index + 1)
        
        // Get indexes and return them
        let ip1 = IndexPath(row: index + 1, section: 0)
        let ip2 = IndexPath(row: index + 2, section: 0)
        let ip3 = IndexPath(row: index + 3, section: 0)
        return [ip1, ip2, ip3]
    }
    
    /** Deletes the replies of the corresponding comment into the list */
    func hideReplies(comment: Comment) -> [IndexPath] {
        // Get index of the comment
        let index = commentList.index(of: comment)!
        
        // Remove all replies
        commentList.remove(at: index + 1)
        commentList.remove(at: index + 1)
        commentList.remove(at: index + 1)
        
        // Get indexes and return them
        let ip1 = IndexPath(row: index + 1, section: 0)
        let ip2 = IndexPath(row: index + 2, section: 0)
        let ip3 = IndexPath(row: index + 3, section: 0)
        return [ip1, ip2, ip3]
    }
    
    // Initialize with random comments
    init() {
        let c1 = Comment()
        let c2 = Reply()
        let c3 = Comment()
        let c4 = Comment()
        let c5 = Reply()
        commentList = [c1, c2, c3, c4, c5]
    }
    
}



// MARK: - UITableView Extension
extension UITableViewCell {
    
    /** Gets the owner tableView of the cell */
    var tableView: UITableView? {
        var view = self.superview
        while (view != nil && view!.isKind(of: UITableView.self) == false) {
            view = view!.superview
        }
        return view as? UITableView
    }
}



extension Bool {
    
    /** Toggle a boolean's state */
    mutating func toggle() {
        self = !self
    }
    
}


