//
//  ReviewsViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 25.12.2020.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsTableView: UITableView!
    
    var productId: Int!{
        didSet {
            self.reviewsInstance.productId = productId
        }
    }
    
    var reviewsInstance = Reviews.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reviewsInstance.fetchReviews()
        reviewsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewsInstance.fetchReviews()
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableReviewCell")
        
        self.reviewsTableView.backgroundColor = UIColor.systemBackground
        reviewsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reviewsInstance.fetchReviews()
        reviewsTableView.reloadData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let _ = reviewsInstance.usersComment {
                return 1
            } else {
                return 0
            }
        } else {
            return reviewsInstance.comments.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReusableReviewCell", for: indexPath) as! ReviewTableViewCell
        print("I")
        if indexPath.section == 0 {
            if let comment = reviewsInstance.usersComment {
                cell.customerNameLabel.text = " "
                cell.commentTimeLabel.text = comment.timestamp.formatDate + "  |"
                cell.commentBody.text = comment.body
                cell.starRatingView.rating = Float(comment.rating)
                cell.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
                cell.layer.borderWidth = 1.5
                cell.layer.cornerRadius = 10
                cell.layer.shadowColor = UIColor.black.cgColor
            }
        } else if indexPath.section == 1 {
            let comment = reviewsInstance.comments[indexPath.row]
            if !comment.is_anonymous {
                if let fName = comment.first_name , let lName = comment.last_name {
                    cell.customerNameLabel.text = "\(fName) \(lName)"
                }
            } else {
                cell.customerNameLabel.text = ""
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

extension ReviewsViewController: ReviewsFetchDelegate {
    func allReviewsAreFetched() {
        self.reviewsTableView.reloadData()
    }
}




protocol ReviewsFetchDelegate {
    func allReviewsAreFetched()}

class Reviews {
    static let shared = Reviews()
    var comments: [CommentData]
    var usersComment: CommentData!
    var productId: Int!
    
    var delegate: ReviewsFetchDelegate?
    let dispatchGroup = DispatchGroup()
    var dataFetched = false {
        didSet{
            if self.dataFetched{
                delegate?.allReviewsAreFetched()
            } else {
                delegate?.allReviewsAreFetched()
            }
        }
    }
    var apiFetchError = false
    var jsonParseError = false
    
    init(){
        self.comments = []
    }
    
    
    func fetchReviews() {
        dispatchGroup.enter()
        DispatchQueue.main.async {
            if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool{
                if isLoggedIn {
                    if let userId = UserDefaults.standard.value(forKey: K.userIdKey) as? Int {
                        APIManager().getUsersComment(productID: self.productId, userID: userId, completionHandler: { result in
                            switch result{
                            case .success(let comment):
                                self.usersComment = comment
                                return
                            case .failure(_):
                                self.usersComment = nil
                            }
                        })
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            APIManager().getComments(productID: self.productId, completionHandler: { result in
                switch result{
                case .success(let comments):
                    if let myComm = self.usersComment {
                        self.comments = comments.filter{$0.id != myComm.id && $0.timestamp != myComm.timestamp}
                    } else {
                        self.comments = comments
                    }
                    return
                case .failure(_):
                    return
                }
            })
        }

        dispatchGroup.leave()
        dispatchGroup.wait()
    }
}

