//
//  ReviewsViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 25.12.2020.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsTableView: UITableView!
    
    var commentsArray: [CommentData] = []
    var productId: Int!
    var myComment: CommentData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        reviewsTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableReviewCell")
        
        self.reviewsTableView.backgroundColor = UIColor.systemBackground
        
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool{
            if isLoggedIn {
                if let userId = UserDefaults.standard.value(forKey: K.userIdKey) as? Int {
                    APIManager().getUsersComment(productID: productId, userID: userId, completionHandler: { result in
                        switch result{
                        case .success(let comment):
                            self.myComment = comment
                            return
                        case .failure(_):
                            self.myComment = nil
                        }
                    })
                }
            }
        }
        
        APIManager().getComments(productID: productId, completionHandler: { result in
            switch result{
            case .success(let comments):
                if let myComm = self.myComment {
                    self.commentsArray = comments.filter{$0.id != myComm.id}
                } else {
                    self.commentsArray = comments
                }
                self.reviewsTableView.reloadData()
                return
            case .failure(_):
                let alertController = UIAlertController(title: "Problem", message: "The comments cannot be fetched", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated:true, completion: nil)
            }
        })
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reviewsTableView.reloadData()
    }
    
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let _ = myComment {
                return 1
            } else {
                return 0
            }
        } else {
            return commentsArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReusableReviewCell", for: indexPath) as! ReviewTableViewCell
        
        if indexPath.section == 0 {
            if let comment = self.myComment {
                cell.customerNameLabel.text = " "
                cell.commentTimeLabel.text = comment.timestamp.formatDate + "  |"
                cell.commentBody.text = comment.body
                cell.starRatingView.rating = Float(comment.rating)
                cell.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
                cell.layer.borderWidth = 1.5
                cell.layer.cornerRadius = 10
                cell.layer.shadowColor = UIColor.black.cgColor
            }
        } else {
            let comment = commentsArray[indexPath.row]
            if !comment.is_anonymous {
                cell.customerNameLabel.text = "\(comment.first_name) \(comment.last_name)"
            }
            cell.commentTimeLabel.text = comment.timestamp.formatDate + "  |"
            cell.commentBody.text = comment.body
            cell.starRatingView.rating = Float(comment.rating)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return reviewsTableView.frame.height / 4
    }
    
}
