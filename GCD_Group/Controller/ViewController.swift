//
//  ViewController.swift
//  GCD_Group
//
//  Created by Amit Chowdhury on 6/24/21.
//

import UIKit

class ViewController: UIViewController {
    var posts = [Post]()
    var coments = [Comment]()
    
    @IBOutlet weak var postTableView:UITableView!
    @IBOutlet weak var comentsTableView:UITableView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        let group = DispatchGroup()
        group.enter()
        let networkManager = NetworkManager()
        networkManager.fetchPostsData(EndPoint.postsUrl) { (posts) in
            self.posts = posts
            group.leave()
        }
        
        group.enter()
        networkManager.fetchCommentsData(EndPoint.commentsUrl) { (coments) in
            self.coments = coments
            group.leave()
        }
        
        group.notify(queue: .main) {
            //Update UI
            self.postTableView.isHidden = !self.postTableView.isHidden
            self.comentsTableView.isHidden = !self.comentsTableView.isHidden

            self.activityIndicator.stopAnimating()
            self.postTableView.reloadData()
            self.comentsTableView.reloadData()
        }
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.postTableView){
            return self.posts.count
        }else {
            return self.coments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.postTableView){
            let postCell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
            postCell.nameLabel.text = self.posts[indexPath.row].title
            return postCell
        }else {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
            commentCell.bodyLabel.text = self.coments[indexPath.row].body
            return commentCell
        }
    }
    
    
}
