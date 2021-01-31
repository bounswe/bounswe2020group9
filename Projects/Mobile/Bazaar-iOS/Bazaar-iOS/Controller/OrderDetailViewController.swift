//
//  OrderDetailViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 26.01.2021.
//

import UIKit

class OrderDetailViewController: UIViewController {
    // ordersTable for orders
    @IBOutlet weak var ordersTableView: UITableView!
    var order_id : Int = -1
    var isCustomer : Bool = true
    var allOrdersInstance = AllOrders.shared
    var allOrdersInstance_vend = AllOrders_vendor.shared
    var allVendorsInstance = AllVendors.shared
    var allProductsInstance = AllProducts.shared
    var allReviewsInstance = MyReviews.shared
    
    var editCommentRowIndex:Int!
    var addCommentProductId:Int!
    let orderStatusArray = ["", "Preparing", "On the Way", "Delivered", "Canceled"]
    
    
    let imageCache = NSCache<NSString,UIImage>()
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving orders", message: "We encountered a problem while retrieving the orders, please check your internet connection.", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        //didLoad statements
        super.viewDidLoad()
        //set delegates
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "ReusableOrderCell")
        
        let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
            // fetch orders
            self.allProductsInstance.fetchAllProducts()
            self.allVendorsInstance.fetchAllVendors()
            self.allOrdersInstance.fetchAllOrders()
            self.allReviewsInstance.fetchReviews()
        })
        networkFailedAlert.addAction(okButton)
        
        self.ordersTableView.backgroundColor = UIColor.systemBackground
        
        //fetch necessary instances
        if !(allProductsInstance.dataFetched) {
            print("products not fetched yet,tryin to fetch right now")
            productsCannotBeFetched()
            self.allProductsInstance.fetchAllProducts()
        }
        if !(allOrdersInstance.dataFetched) {
            print("orders not fetched yet,tryin to fetch right now")
            ordersCannotBeFetched()
            self.allOrdersInstance.fetchAllOrders()
        }
        if !(allVendorsInstance.dataFetched) {
            print("vendors not fetched yet,tryin to fetch right now")
            vendorsCannotBeFetched()
            self.allVendorsInstance.fetchAllVendors()
        }
        if !(allReviewsInstance.dataFetched) {
            reviewsCannotBeFetched()
            self.allReviewsInstance.fetchReviews()
        }
        
    }
    
    //backButton Pressed
    @IBAction func didBackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        ordersTableView.reloadData()
        ordersTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "orderDetailToEditReviewSegue" {
            if let popoverVC = segue.destination as? AddReviewViewController {
                if self.editCommentRowIndex != nil {
                    popoverVC.reviewToEdit = allReviewsInstance.comments[self.editCommentRowIndex]
                    self.editCommentRowIndex = nil
                }
            }
        } else if segue.identifier == "orderDetailToAddReviewSegue" {
            if let popoverVC = segue.destination as? AddReviewViewController {
                if self.addCommentProductId != nil {
                    popoverVC.productToReview = self.addCommentProductId
                    self.addCommentProductId = nil
                }
            }
        }
    }
    
    
    
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    //GET number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("returned order count")
        if tableView == ordersTableView {
            // print(allOrdersInstance.allOrders.filter{$0.id==order_id}.count)
            if (isCustomer){
                return (allOrdersInstance.allOrders.filter{$0.id==order_id})[0].deliveries.count
            }else{
                return (allOrdersInstance_vend.allOrders.filter{$0.id==order_id}).count
            }
        }else {
            print("Should not see this.")
            return 5 //random cell count, should not come here
        }
    }
    
    //set cells for every index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "ReusableOrderCell", for: indexPath) as! OrderCell
        // set default image
        cell.ProductImage?.image = UIImage(named:"xmark.circle")
        let product:ProductData
        if (isCustomer){
            //filter orders
            let filteredOrders:[OrderData_Cust] = allOrdersInstance.allOrders.filter{$0.id==order_id}
           //set order instance
            let order = filteredOrders[0]
            print("Order deliveries count:" + String(order.deliveries.count))
            let delivery = order.deliveries[indexPath.row]
            print("Product ID: " + String(delivery.product_id))
            product = allProductsInstance.allProducts.filter{$0.id==delivery.product_id}[0]            //filteredProducts[delivery.product_id]
            //let vendor = vendors_dict[delivery.vendor]!
            let orderStatus=orderStatusArray[delivery.current_status]
            cell.delivery_id=delivery.id
            cell.product_id = product.id
            cell.Cancel_OrderButton.isHidden=true
            cell.Name_BrandLabel.text = product.name + " - " + product.brand//product.detail + ", " +
            cell.Name_BrandLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.Price_StatusLabel.text = "₺" + String(product.price) + ", Status: " + orderStatus
            cell.Price_StatusLabel.font = UIFont.systemFont(ofSize: 13, weight: .black)
            cell.VendorLabel.text = "Vendor Company : " + AllVendors.shared.allVendors.filter{$0.id == product.vendor}[0].company//vendor.company
            cell.VendorLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            cell.AmountLabel.text = "Amount : " + String(delivery.amount)
            cell.AmountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            cell.DatesLabel.text = "Order Date: " + delivery.timestamp.prefix(10) + " Estimated Delivery : " + delivery.delivery_time.prefix(10)
            cell.DatesLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            cell.AdressLabel.text = "Order Adress: " + delivery.delivery_address.address + " " + delivery.delivery_address.city
            cell.AdressLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            print("complete setting order cell")
            cell.isUserInteractionEnabled=false
        }else{
            //filter orders
            let filteredOrders:[VendorOrderData] = allOrdersInstance_vend.allOrders.filter{$0.id==order_id}
            //select order
            let order = filteredOrders[0]
            let delivery = order
            print("Product ID: " + String(delivery.product_id))
            product = allProductsInstance.allProducts.filter{$0.id==delivery.product_id}[0]            //filteredProducts[delivery.product_id]
        
            //let vendor = vendors_dict[delivery.vendor]!
            let orderStatus=orderStatusArray[delivery.current_status]
            cell.delivery_id=delivery.id
            cell.product_id = product.id
            cell.Cancel_OrderButton.isHidden=true
            cell.Name_BrandLabel.text = product.name + " - " + product.brand//product.detail + ", " +
            cell.Name_BrandLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.Price_StatusLabel.text = "₺" + String(product.price) + ", Status: " + orderStatus
            cell.Price_StatusLabel.font = UIFont.systemFont(ofSize: 13, weight: .black)
            cell.VendorLabel.text = "Vendor Company : " + AllVendors.shared.allVendors.filter{$0.id == product.vendor}[0].company//vendor.company
            cell.VendorLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            cell.AmountLabel.text = "Amount : " + String(delivery.amount)
            cell.AmountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            cell.DatesLabel.text = "Order Date: " + delivery.timestamp.prefix(10) + " Estimated Delivery : " + delivery.delivery_time.prefix(10)
            cell.DatesLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            cell.AdressLabel.text = "Order Adress: " + delivery.delivery_address.address + " " + delivery.delivery_address.city
            cell.AdressLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            print("complete setting order cell")
            cell.isUserInteractionEnabled=false
        }
        
        

        //put image for product
        if allProductsInstance.allImages.keys.contains(product.id) {
            cell.ProductImage.image = allProductsInstance.allImages[product.id]
            cell.ProductImage.contentMode = .scaleAspectFit
            print("1: Name: \(product.name) :Product ID: \(product.id)")
        } else {
            print("2: \(product.name)")
            if let url = product.picture {
                do{
                    try cell.ProductImage.loadImageUsingCache(withUrl: url, forProduct: product)
                    cell.ProductImage.contentMode = .scaleAspectFit
                } catch let error {
                    print(error)
                    cell.ProductImage.image = UIImage(named:"xmark.circle")
                    cell.ProductImage.tintColor = UIColor.lightGray
                    cell.ProductImage.contentMode = .center
                }
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let filteredOrders:[OrderData_Cust] = allOrdersInstance.allOrders.filter{$0.id==order_id}
        let order = filteredOrders[0]
        let delivery = order.deliveries[indexPath.row]
        let filteredReviews = allReviewsInstance.comments.filter{$0.product==delivery.product_id}
        if filteredReviews.count==0 {
            let add = UIContextualAction(style: .destructive, title: "Add Review") { (action, sourceView, completionHandler) in
                self.addCommentProductId = delivery.product_id
                self.performSegue(withIdentifier: "orderDetailToAddReviewSegue", sender: nil)
            }
            add.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [add])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        }else {
            let edit = UIContextualAction(style: .destructive, title: "Edit Review") { (action, sourceView, completionHandler) in
                self.editCommentRowIndex = indexPath.row
                self.performSegue(withIdentifier: "orderDetailToEditReviewSegue", sender: nil)
            }
            edit.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [edit])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        }
        
    }
    
}
//setting delegate-functions
extension OrderDetailViewController: AllProductsFetchDelegate {
    func allProductsAreFetched() {
        self.stopIndicator()
    }
    
    func productsCannotBeFetched() {
        startIndicator()
        presentAlert()
        
    }
    
    func presentAlert() {
        if allProductsInstance.apiFetchError {
            self.networkFailedAlert.message = "We couldn't connect to the network, please check your internet connection."
        }
        if allProductsInstance.jsonParseError {
            self.networkFailedAlert.message = "There is an internal problem in the system."
        }
        if !self.networkFailedAlert.isBeingPresented {
            self.present(networkFailedAlert, animated:true, completion: nil)
        }
    }
}

extension OrderDetailViewController: AllVendorsFetchDelegate {
    func allVendorsAreFetched() {
        self.stopIndicator()
    }
    
    func vendorsCannotBeFetched() {
        startIndicator()
    }
}

extension OrderDetailViewController: MyReviewsFetchDelegate {
    func allReviewsAreFetched() {
        self.stopIndicator()
    }
    
    func reviewsCannotBeFetched() {
        startIndicator()
    }
}

extension OrderDetailViewController: AllOrdersFetchDelegate {
    func allOrdersAreFetched() {
        //self.orders = self.allOrdersInstance.allOrders
        self.stopIndicator()
    }
    
    func ordersCannotBeFetched() {
        startIndicator()
    }
}
// MARK: - IndicatorView
extension OrderDetailViewController {
    func startIndicator() {
        ordersTableView.isHidden = true
        print("Start-Indicator")
    }
    
    func createIndicatorView() {
        ordersTableView.isHidden = true
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.ordersTableView.isHidden = false
            self.ordersTableView.reloadData()
            
        }
    }
}
