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
    var userCart:[CartProduct] = []
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCart()
    }
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
                fetchCart()
                print("usercart:",userCart)
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
    }
    
    func fetchCart() {
        let user = UserDefaults.standard.value(forKey: K.userIdKey) as! String
        APIManager().getCart(user: user, completionHandler: {(result) in
            print(result)
            switch result {
            case .success(let cart):
                DispatchQueue.main.async {
                    self.userCart = cart
                    print("cart:",cart)
                    self.stopIndicator()
                    if(self.userCart.isEmpty) {
                        self.emptyCartLabel.text = "Your cart is empty."
                        self.emptyCartLabel.isHidden = false
                        self.cartTableView.isHidden = true
                        self.loadingContainerView.isHidden = true
                        self.view.bringSubviewToFront(self.emptyCartLabel)
                    }
                    self.cartTableView.reloadData()
                    self.reloadTotalPrice()
                    
                }
               
            case .failure(let error):
                self.userCart = []
                // error ver 
            }
        })
        
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
    
    func reloadTotalPrice () {
        let cartProdIDs = userCart.map{$0.product}
        let cartProducts = AllProducts.shared.allProducts.filter {cartProdIDs.contains($0.id)}
        let totalPrice = cartProducts.map{$0.price}.reduce(0,+)
        self.totalPriceLabel.text = "Total:\n₺" + String(totalPrice)
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
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if let productDetailVC = segue.destination as? ProductDetailViewController {
            let indexPath = self.cartTableView.indexPathForSelectedRow
            if (indexPath != nil) {
                let product = AllProducts.shared.allProducts.filter {$0.id == userCart[indexPath!.row].product}[0]
                productDetailVC.product = product
            }
        }
     }
     
    
}

extension MyCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: ", userCart.count)
        return userCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        /*cell.amountTextField.text = "1"
        cell.productBrandLabel.text = "rolex"
        cell.productImageView.image = UIImage(named: "1")
        cell.productPriceLabel.text = "₺"+"15000.00"*/
        let product = AllProducts.shared.allProducts.filter {$0.id == userCart[indexPath.row].product}[0]
        print("product:",product)
        cell.product = product
        cell.productNameLabel.text = product.name
        cell.productBrandLabel.text = product.brand
        cell.productPriceLabel.text = "₺"+String(product.price)
        cell.amountStepper.value = Double(userCart[indexPath.row].amount)
        cell.amountTextField.text = String(userCart[indexPath.row].amount)
        if let url = product.picture {
            do{
                try cell.productImageView.loadImageUsingCache(withUrl: url)
            } catch let error {
                print(error)
                cell.productImageView.image = UIImage(named:"xmark.circle")
                cell.productImageView.tintColor = UIColor.lightGray
            }
        } else {
            cell.productImageView.image = UIImage(named:"xmark.circle")
            cell.productImageView.tintColor = UIColor.lightGray
            cell.productImageView.contentMode = .center
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height/6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = AllProducts.shared.allProducts.filter {$0.id == userCart[indexPath.row].product}[0]
        performSegue(withIdentifier: "cartToProductDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            let product = AllProducts.shared.allProducts.filter {$0.id == userCart[indexPath.row].product}[0]
            userCart.remove(at: indexPath.row)
            APIManager().deleteProductFromCart(productID: product.id, completionHandler:{result in
                switch result {
                case .success(let cart):
                    DispatchQueue.main.async {
                        self.userCart = cart
                        self.cartTableView.reloadData()
                    }
                case .failure(let err):
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Problem", message: "The item cannot be deleted from your cart due to a network problem. Please try again later.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alertController, animated:true, completion: nil)
                    }
                }
            })
        }
    }
    
    
}
