//
//  MyCartViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 12.11.2020.
//

import UIKit

class MyCartViewController: UIViewController {
    
    @IBOutlet weak var emptyCartLabel: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.value(forKey: K.isLoggedinKey))
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool {
            if (isLoggedIn) {
                loadingView.isHidden = false
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                emptyCartLabel.text = "Your cart is empty."
                fetchCart()
                print("of1")
            } else {
                loadingView.isHidden = true
                activityIndicator.isHidden = true
                cartTableView.isHidden = true
                emptyCartLabel.isHidden = false
                emptyCartLabel.text = "You should be logged in to view your cart."
                print("of2")
            }
        } else {
            print("********problem")
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func fetchCart() {
        dispatchGroup.enter()
        APIManager().getCart(user: K.user_id, completionHandler: { result in
            switch result {
            case .success(let cart):
                DispatchQueue.main.async {
                    print("******cart fetched")
                    print(cart)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                    print("***** error happened")
                }
            }
        })
        dispatchGroup.leave()
        dispatchGroup.wait()
        
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
