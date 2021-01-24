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
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool {
            if (isLoggedIn) {
                startIndicator()
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
            loadingContainerView.isHidden = true
            activityIndicator.isHidden = true
            cartTableView.isHidden = true
            emptyCartLabel.isHidden = false
            emptyCartLabel.text = "You should be logged in to view your cart."
            emptyCartLabel.isHidden = false
            buyContainerView.isHidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        totalPriceLabel.text = "Total:\n₺"
        cartTableView.tableFooterView = UIView(frame: .zero)
        cartTableView.tableFooterView?.isHidden = true
        buyContainerView.isHidden = true
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool {
            if (isLoggedIn) {
                startIndicator()
                fetchCart()
            } else {
                loadingContainerView.isHidden = true
                activityIndicator.isHidden = true
                cartTableView.isHidden = true
                emptyCartLabel.isHidden = false
                emptyCartLabel.text = "You should be logged in to view your cart."
                buyContainerView.isHidden = true
            }
        } else {
            loadingContainerView.isHidden = true
            activityIndicator.isHidden = true
            cartTableView.isHidden = true
            emptyCartLabel.isHidden = false
            emptyCartLabel.text = "You should be logged in to view your cart."
            emptyCartLabel.isHidden = false
            buyContainerView.isHidden = true
        }
    }
    
    func fetchCart() {
        if let user = UserDefaults.standard.value(forKey: K.userIdKey) as? Int {
            APIManager().getCart(user: user, completionHandler: {(result) in
                switch result {
                case .success(let cart):
                    DispatchQueue.main.async {
                        self.userCart = cart
                        self.stopIndicator()
                        if(self.userCart.count == 0) {
                            self.emptyCartLabel.text = "Your cart is empty."
                            self.emptyCartLabel.isHidden = false
                            self.cartTableView.isHidden = true
                            self.buyContainerView.isHidden = true
                        } else {
                            self.buyContainerView.isHidden = false
                            self.cartTableView.reloadData()
                            self.reloadTotalPrice()
                        }
                    }
                    
                case .failure(let error):
                    self.userCart = []
                // error ver 
                }
            })
        }else {
            print(UserDefaults.standard.value(forKey: K.userIdKey))
        }
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
        var totalPrice:Double = 0.0
        for product in userCart {
            let prod = AllProducts.shared.allProducts.filter{$0.id == product.product}[0]
            totalPrice = totalPrice + (Double(product.amount) * prod.price)
        }
        self.totalPriceLabel.text = "Total:\n₺" + String(totalPrice.rounded(toPlaces: 2))
    }
    
    func startIndicator() {
        loadingContainerView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        cartTableView.isHidden = true
        emptyCartLabel.isHidden = true
    }
    
    func stopIndicator() {
        self.loadingContainerView.isHidden = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.cartTableView.isHidden = false
        self.emptyCartLabel.isHidden = true
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
        else if let paymentVC = segue.destination as? PaymentViewController {
            paymentVC.totalPriceText = self.totalPriceLabel.text
            
            let myDict = self.userCart.reduce(into: [Int: Int]()) {
                $0[$1.product] = $1.amount
            }
            paymentVC.deliveries = myDict
        }
     }
     
    
}

extension MyCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        /*cell.amountTextField.text = "1"
        cell.productBrandLabel.text = "rolex"
        cell.productImageView.image = UIImage(named: "1")
        cell.productPriceLabel.text = "₺"+"15000.00"*/
        let product = AllProducts.shared.allProducts.filter {$0.id == userCart[indexPath.row].product}[0]
        cell.product = product
        cell.amountChangedDelegate = self
        cell.productNameLabel.text = product.name
        cell.productBrandLabel.text = product.brand
        cell.productPriceLabel.text = "₺"+String(product.price)
        cell.amountStepper.value = Double(userCart[indexPath.row].amount)
        cell.amountTextField.text = String(userCart[indexPath.row].amount)
        if AllProducts.shared.allImages.keys.contains(product.id) {
            cell.productImageView.image = AllProducts.shared.allImages[product.id]
            cell.productImageView.contentMode = .scaleAspectFit
            print("1: \(product.name)")
        } else {
            print("2: \(product.name)")
            if let url = product.picture {
                do{
                    try cell.productImageView.loadImageUsingCache(withUrl: url, forProduct: product)
                    cell.productImageView.contentMode = .scaleAspectFit
                } catch let error {
                    print(error)
                    cell.productImageView.image = UIImage(named:"xmark.circle")
                    cell.productImageView.tintColor = UIColor.lightGray
                    cell.productImageView.contentMode = .center
                }
            }
        }
//        if let url = product.picture {
//            do{
//                try cell.productImageView.loadImageUsingCache(withUrl: url, forProduct: product)
//            } catch let error {
//                print(error)
//                cell.productImageView.image = UIImage(named:"xmark.circle")
//                cell.productImageView.tintColor = UIColor.lightGray
//            }
//        } else {
//            cell.productImageView.image = UIImage(named:"xmark.circle")
//            cell.productImageView.tintColor = UIColor.lightGray
//            cell.productImageView.contentMode = .center
//        }
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
                        self.reloadTotalPrice()
                        if(cart.isEmpty) {
                            self.emptyCartLabel.text = "Your cart is empty."
                            self.emptyCartLabel.isHidden = false
                            self.cartTableView.isHidden = true
                            self.loadingContainerView.isHidden = true
                        }
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

extension MyCartViewController: CartItemAmountChangedDelegate {
    func amountChangedForItem(product: ProductData, amount: Int) {
        reloadTotalPrice()
    }
    
    
}

extension Double {
    /// Rounds the double to decimal places value
    // from: https://stackoverflow.com/a/32581409
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

