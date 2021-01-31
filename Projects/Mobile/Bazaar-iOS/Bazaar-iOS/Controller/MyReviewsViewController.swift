//
//  MyReviewsViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 28.01.2021.
//

import UIKit

class MyReviewsViewController: UIViewController {

    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var editRowIndex:Int!
    var products:[Int:ProductData]!
    
    var reviewsInstance = MyReviews.shared
    
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving lists", message: "We encountered a problem while retrieving the lists, please check your internet connection.", preferredStyle: .alert)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reviewsInstance.fetchReviews()
        reviewsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reviewsInstance.fetchReviews()
        reviewsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsInstance.delegate = self
        //createIndicatorView()
        let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
           self.reviewsInstance.fetchReviews()
        })
        networkFailedAlert.addAction(okButton)
        reviewsTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableReviewCell")
        let alertController = UIAlertController(title: nil, message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
            self.stopIndicator()
            DispatchQueue.main.async {
                self.reviewsTableView.isHidden = true
            }
        }))
        self.reviewsInstance.fetchReviews()
        if !(reviewsInstance.dataFetched) {
            //startIndicator()
            self.reviewsInstance.fetchReviews()
        }
        self.view.bringSubviewToFront(reviewsTableView)
        self.reviewsTableView.reloadData()
        
        self.reviewsTableView.backgroundColor = UIColor.systemBackground
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "reviewsToEditReviewSegue" {
            if let popoverVC = segue.destination as? AddReviewViewController {
                if self.editRowIndex != nil {
                    popoverVC.reviewToEdit = reviewsInstance.comments[self.editRowIndex]
                    self.editRowIndex = nil
                }
            }
        }
        
    }
    
    @IBAction func didBackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension MyReviewsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewsInstance.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReusableReviewCell", for: indexPath) as! ReviewTableViewCell
        let review:CommentData = reviewsInstance.comments[indexPath.row]
        cell.commentBody.text = review.body
        cell.commentTimeLabel.text = review.timestamp.formatDate
        cell.customerNameLabel.text = ""
        cell.starRatingView.rating = Float(review.rating)
        if reviewsInstance.allImages.keys.contains(review.product) {
            cell.productImageView.image = reviewsInstance.allImages[review.product]
            cell.productImageView.contentMode = .scaleAspectFit
        } else {
            if let url = reviewsInstance.products[review.product]?.picture {
                do{
                    try cell.productImageView.loadImageUsingCache(withUrl: url, forProduct: reviewsInstance.products[review.product])
                    cell.productImageView.contentMode = .scaleAspectFit
                } catch let error {
                    print(error)
                    cell.productImageView.image = UIImage(named:"xmark.circle")
                    cell.productImageView.tintColor = UIColor.lightGray
                    cell.productImageView.contentMode = .center
                }
            }  else {
                cell.productImageView.image = UIImage(named:"xmark.circle")
                cell.productImageView.tintColor = UIColor.lightGray
                cell.productImageView.contentMode = .center
            }
        }
        cell.productImageView.isHidden = false
        //cell product name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3.5
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let comment = reviewsInstance.comments[indexPath.row]
        let alertController = UIAlertController(title: nil, message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                print("index path of delete: \(indexPath)")
            completionHandler(true)
            
            APIManager().deleteComment(c_id: comment.id) { (result) in
                switch result {
                case .success(_):
                    alertController.message = "Review is successfully deleted"
                    self.present(alertController, animated: true, completion: nil)
                    self.reviewsInstance.comments.remove(at: indexPath.row)
                    self.reviewsTableView.reloadData()
                case .failure(_):
                    alertController.message = "Review cannot be deleted"
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .destructive, title: "Edit") { (action, sourceView, completionHandler) in
            self.editRowIndex = indexPath.row
            self.performSegue(withIdentifier: "reviewsToEditReviewSegue", sender: nil)
        }
        edit.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [edit])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
}

extension MyReviewsViewController: MyReviewsFetchDelegate {
    func allReviewsAreFetched() {
        stopIndicator()
        self.reviewsTableView.reloadData()
    }
    func reviewsCannotBeFetched() {
        //startIndicator()
        presentAlert()
    }
    func presentAlert() {
        if reviewsInstance.apiFetchError {
            self.networkFailedAlert.message = "We couldn't connect to the network, please check your internet connection."
        }
        if reviewsInstance.jsonParseError {
            self.networkFailedAlert.message = "There is an internal problem in the system."
        }
        if !self.networkFailedAlert.isBeingPresented {
            self.present(networkFailedAlert, animated:true, completion: nil)
        }
    }
}


extension MyReviewsViewController {
    func startIndicator() {
        self.view.bringSubviewToFront(loadingView)
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        reviewsTableView.isHidden = true
    }

    func createIndicatorView() {
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        reviewsTableView.isHidden = true
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.view.sendSubviewToBack(self.loadingView)
            self.reviewsTableView.isHidden = false
            self.reviewsTableView.isUserInteractionEnabled = true
            self.reviewsTableView.reloadData()
        }
    }
}



protocol MyReviewsFetchDelegate {
    func allReviewsAreFetched()
    func reviewsCannotBeFetched()
    func presentAlert()
}

class MyReviews {
    static let shared = MyReviews()
    var comments: [CommentData]
    var usersComment: CommentData!
    var allImages: Dictionary<Int, UIImage>
    var products: Dictionary<Int, ProductData>
    var productId: Int!
    
    var delegate: MyReviewsFetchDelegate?
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
        self.allImages = Dictionary()
        self.products = Dictionary()
    }
    
    
    func fetchReviews() {
        dispatchGroup.enter()
        
        APIManager().getAllCommentsOfUser( completionHandler: { result in
            switch result {
            case .success(let comments):
                self.dataFetched = true
                self.comments = comments
                self.delegate?.allReviewsAreFetched()
            case .failure(_):
                self.dataFetched = false
                self.comments = []
                self.delegate?.reviewsCannotBeFetched()
            }
        })
        
        for c in comments {
            APIManager().getProduct(p_id: c.product, completionHandler: { result in
                switch result {
                case .success(let prod):
                    self.products[prod.id] = prod
                    let group = DispatchGroup()
                    let serialQueue = DispatchQueue(label: "serialQueue")
                    group.enter()
                    if let pic = prod.picture {
                        let url = URL(string: prod.picture!)
                        URLSession(configuration: .default).dataTask(with: url!) { (data, response, error) in
                            guard let data = data, let image = UIImage(data: data), error == nil else { group.leave(); return }
                            serialQueue.async {
                                self.allImages[prod.id] = image
                                group.leave()
                            }
                        }.resume()
                    } else {
                        group.leave()
                    }
                case .failure(_):
                    return
                }
            })
        }
        dispatchGroup.leave()
        dispatchGroup.wait()
    }
}


