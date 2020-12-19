//
//  MyCartViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 12.11.2020.
//

import UIKit

class MyCartViewController: UIViewController {
    
    @IBOutlet weak var emptyCartLabel: UILabel!
    @IBOutlet weak var loadingContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var buyContainerView: UIView!
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        totalPriceLabel.text = "Total:\n₺15000"
        cartTableView.tableFooterView = UIView(frame: .zero)
        cartTableView.tableFooterView?.isHidden = true
        print(UserDefaults.standard.value(forKey: K.isLoggedinKey)!)
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool {
            if (isLoggedIn) {
                startIndicator()
                emptyCartLabel.text = "Your cart is empty."
                fetchCart()
            } else {
                loadingContainerView.isHidden = true
                activityIndicator.isHidden = true
                cartTableView.isHidden = true
                emptyCartLabel.isHidden = false
                emptyCartLabel.text = "You should be logged in to view your cart."
                emptyCartLabel.isHidden = false
                buyContainerView.isHidden = true
            }
        } else {
            print("********problem")
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func fetchCart() {
        print("**** am i here?")
        let user = UserDefaults.standard.value(forKey: K.userIdKey) as! String
        print("user:", user)
        APIManager().getCart(user: user, completionHandler: {(result) in
            print(result)
        })
        
        stopIndicator()
        /*APIManager().getCart(user:user , completionHandler: { result in
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
        })*/
        
    }
    
    func startIndicator() {
        loadingContainerView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        cartTableView.isHidden = true
        emptyCartLabel.isHidden = true
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.loadingContainerView.isHidden = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.cartTableView.isHidden = false
            self.emptyCartLabel.isHidden = true
        }
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

extension MyCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        cell.amountTextField.text = "1"
        cell.productBrandLabel.text = "rolex"
        cell.productImageView.image = UIImage(named: "1")
        cell.productPriceLabel.text = "₺"+"15000.00"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height/5
    }
    
    
}
