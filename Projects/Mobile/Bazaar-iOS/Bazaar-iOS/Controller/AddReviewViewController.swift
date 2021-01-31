//
//  AddReviewViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 28.01.2021.
//

import UIKit

class AddReviewViewController: UIViewController {

    @IBOutlet weak var addReviewTitle: UILabel!
    @IBOutlet weak var addReviewButton: UIButton!
    @IBOutlet weak var commentLabel: UITextField!
    @IBOutlet weak var isAnonButton: RadioButton!
    @IBOutlet weak var frameView: UIView!
    
    var isAnon = false
    
    var productToReview:Int?
    var reviewToEdit:CommentData?
    
    
    override func viewDidLoad() {
        frameView.layer.shadowColor = UIColor.black.cgColor
        self.view.bringSubviewToFront(frameView)
        if let review = reviewToEdit {
            addReviewButton.setTitle("Edit", for: .normal)
            addReviewTitle.text = "Edit Review"
            commentLabel.placeholder = review.body
            isAnonButton.isSelected = review.is_anonymous
            self.isAnon =  review.is_anonymous
        }
    }
    
    @IBAction func addReviewButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        if let review = reviewToEdit {
            if let commentBody = commentLabel.text{
                let comment = ((commentBody.count) > 0) ? commentBody : review.body
                APIManager().updateComment(c_id: review.id, body: comment, rating: review.rating, is_anon: isAnon, product: review.product) { (result) in
                    switch result {
                    case .success(let comment):
                        alertController.message = "Your review is updated successfully."
                        self.present(alertController, animated: true, completion: nil)
                        self.dismiss(animated: false, completion: nil)
                    case .failure(_):
                        alertController.message = "The review cannot be edited"
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            }
        } else if let comment = commentLabel.text {
            if !(comment.count > 0) {
                alertController.message = "Please enter a Comment"
                self.present(alertController, animated: true, completion: nil)
            } else {
                APIManager().addComment(body: comment, rating: 3, is_anon: isAnon, product: productToReview!){ (result) in
                    switch result {
                    case .success(let comment):
                        alertController.message = "Your review has been added successfully . Thank you!"
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
                            action in
                            self.dismiss(animated: false, completion: nil)
                        }))
                        self.present(alertController, animated: true, completion: nil)
                    case .failure(_):
                        alertController.message = "The review cannot be added"
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func isAnonButtonPressed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        self.isAnon = sender.isSelected
    }
}
