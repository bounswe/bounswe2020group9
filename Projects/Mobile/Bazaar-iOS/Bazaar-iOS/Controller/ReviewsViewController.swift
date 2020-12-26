//
//  ReviewsViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 25.12.2020.
//

import UIKit

class ReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsTableView: UITableView!
   // @IBOutlet weak var loadingView: UIView!
   // @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var commentsArray: [CommentData] = []
    var productId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        reviewsTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableReviewCell")
        self.reviewsTableView.backgroundColor = UIColor.systemBackground
        
        APIManager().getComments(productID: productId, completionHandler: { result in
            switch result{
            case .success(let comments):
                self.commentsArray = comments
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReusableReviewCell", for: indexPath) as! ReviewTableViewCell
        let comment = commentsArray[indexPath.row]
        cell.customerNameLabel.text = "\(comment.first_name) \(comment.last_name)"
        //timestamp to date convert
        cell.commentTimeLabel.text = comment.timestamp.formatDate
        cell.commentBody.text = comment.body
        cell.starRatingView.rating = Float(comment.rating)
        return cell
    }
    
}
