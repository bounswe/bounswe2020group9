//
//  VendorMyOrderViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 12.01.2021.
//

import UIKit

class VendorMyOrdersViewController: UIViewController {
    @IBOutlet weak var ordersTableView: UITableView!
    var allOrdersInstance = AllOrders_vendor.shared
    
    var allProductsInstance = AllProducts.shared
    var allVendorsInstance = AllVendors.shared
    
    let orderStatusArray = ["", "Preparing", "On the Way", "Delivered", "Canceled"]
    
    var cancel_button_delivery_id :Int = -1
    var cancel_button_status :Int = -1
    var products_dict: [Int: ProductData] = [:]
    var vendors_dict: [Int: VendorData] = [:]
    
    var orders: [VendorOrderData] = []
    var products: [ProductData] = []
    var vendors:[VendorData] = []
    
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving orders", message: "We encountered a problem while retrieving the orders, please check your internet connection.", preferredStyle: .alert)
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        ordersTableView.reloadData()
        ordersTableView.tableFooterView = UIView(frame: .zero)
    }
    
    // set up necessary variables and cells , fetch necessary items
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        allProductsInstance.delegate = self
        allVendorsInstance.delegate = self
        allOrdersInstance.delegate = self
        let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
            // fetch orders
            self.allProductsInstance.fetchAllProducts()
            self.allVendorsInstance.fetchAllVendors()
            self.allOrdersInstance.fetchAllOrders()
        })
        networkFailedAlert.addAction(okButton)
        ordersTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "ReusableOrderCell")
        if !(allProductsInstance.dataFetched) {
            print("products not fetched yet,tryin to fetch right now")
            productsCannotBeFetched()
            self.allProductsInstance.fetchAllProducts()
        }else {
            for prod in allProductsInstance.allProducts {
                products_dict[prod.id]=prod
            }
        }
        if !(allVendorsInstance.dataFetched) {
            print("vendors not fetched yet,tryin to fetch right now")
            vendorsCannotBeFetched()
            self.allVendorsInstance.fetchAllVendors()
        }else{
            for vendor in allVendorsInstance.allVendors {
                vendors_dict[vendor.id]=vendor
            }
        }
        self.allOrdersInstance.fetchAllOrders()
        
    }
    
    
}

extension VendorMyOrdersViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("returned order count")
        if tableView == ordersTableView {
            print(allOrdersInstance.allOrders.count)
            return allOrdersInstance.allOrders.count
        }else {
            print("Should not see this.")
            return 5
        }
    }
    //for cancel button not necessary for now
    @objc func cancel_button_clicked(_ sender : UIButton){
        print("Button clicked. ")
        // need to take status information and set to cancel_button_status
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        APIManager().deleteOrder(delivery_id: cancel_button_delivery_id,status:cancel_button_status) { (result) in
            switch result {
            case .success(let message):
                self.dismiss(animated: false, completion: nil)
                alertController.message = "Order status succesfully changed."
                self.present(alertController, animated: true, completion: nil)
            case .failure(_):
                alertController.message = "Order status did not changed. Try again later."
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    //set order cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("setting order cell : "+String(indexPath.row))
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "ReusableOrderCell", for: indexPath) as! OrderCell
        cell.ProductImage?.image = UIImage(named:"xmark.circle")
        cell.Cancel_OrderButton.isHidden=true
        let filteredOrders:[VendorOrderData] = allOrdersInstance.allOrders
        let order = filteredOrders[indexPath.row]
        let delivery = order
        print("Product ID: " + String(delivery.product_id))
        let product = allProductsInstance.allProducts.filter{$0.id==delivery.product_id}[0]               //filteredProducts[delivery.product_id]
        //let vendor = vendors_dict[delivery.vendor]!
        let orderStatus=orderStatusArray[delivery.current_status]
        cell.delivery_id=delivery.id
        
        cell.Cancel_OrderButton.isHidden=true
        cell.Name_BrandLabel.text = product.name + " - " + product.brand//product.detail + ", " +
        cell.Name_BrandLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        cell.Price_StatusLabel.text = "₺" + String(product.price) + ", Status: " + orderStatus
        cell.Price_StatusLabel.font = UIFont.systemFont(ofSize: 13, weight: .black)
        
        cell.VendorLabel.text = "Order adress :" + String(order.delivery_address.address + " " + order.delivery_address.city)
        cell.VendorLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        cell.AmountLabel.text = "Order Date: " + delivery.timestamp.prefix(10) + " Estimated Delivery : " + delivery.delivery_time.prefix(10)
        cell.AmountLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.DatesLabel.text = "Click to see order details."
        cell.DatesLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        //cell.AmountLabel.isHidden=true
        //cell.DatesLabel.isHidden=true
        
        cell.AdressLabel.text = "Order Adress: " + delivery.delivery_address.address + " " + delivery.delivery_address.city
        cell.AdressLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        print("complete setting order cell")
// set images
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
    //swipe action change status of the order
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let order = allOrdersInstance.allOrders[indexPath.row]
        let canceling_dId = order.id
        let order_new_status_id=(order.current_status+1)%5
        print(canceling_dId)
        print("hey")
        if (order_new_status_id != 0 && order_new_status_id != 4){
            let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            let delete = UIContextualAction(style: .destructive, title: "Mark as: " + orderStatusArray[order_new_status_id]) { (action, sourceView, completionHandler) in
                print("index path of cancel: \(indexPath)")
                completionHandler(true)
                DispatchQueue.main.async {
                    APIManager().deleteOrder(delivery_id: canceling_dId, status: order_new_status_id){ (result) in
                        switch result {
                        case .success(_):
                            alertController.message = "\(canceling_dId) is successfully changed status to" + self.orderStatusArray[order_new_status_id]
                            self.present(alertController, animated: true, completion: nil)
                            tableView.reloadData()
                        case .failure(_):
                            alertController.message = "\(canceling_dId) could not change status"
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            delete.backgroundColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
            let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
            swipeActionConfig.performsFirstActionWithFullSwipe = false
            return swipeActionConfig
        }
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    //take necessary steps before leaving to details Page
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = ordersTableView.indexPathForSelectedRow
        let order_id = allOrdersInstance.allOrders[indexPath!.row].id
        if let detailResults = segue.destination as? OrderDetailViewController {
            detailResults.order_id = order_id
            detailResults.isCustomer = false
            
        }
    
    }
    //perfomr segue to detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("HERE CLICKED")
        
        performSegue(withIdentifier: "orderVendToDetailSegue", sender: nil)
        
    }
    
    
}
//set delegates-functions
extension VendorMyOrdersViewController: AllProductsFetchDelegate {
    func allProductsAreFetched() {
        for prod in allProductsInstance.allProducts {
            products_dict[prod.id]=prod
            print("ADDED " + String(prod.id))
        }
        self.stopIndicator()
        self.ordersTableView.reloadData()
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

extension VendorMyOrdersViewController: AllVendorsFetchDelegate {
    func allVendorsAreFetched() {
        self.stopIndicator()
        self.vendors = self.allVendorsInstance.allVendors
        for vendor in allVendorsInstance.allVendors {
            vendors_dict[vendor.id]=vendor
        }
        self.ordersTableView.reloadData()
    }
    
    func vendorsCannotBeFetched() {
        startIndicator()
    }
}
extension VendorMyOrdersViewController: AllOrdersVendorFetchDelegate {
    func allOrdersAreFetched() {
        self.stopIndicator()
        self.orders = self.allOrdersInstance.allOrders
        self.ordersTableView.reloadData()
    }
    
    func ordersCannotBeFetched() {
        startIndicator()
    }
}





// MARK: - IndicatorView
extension VendorMyOrdersViewController {
    func startIndicator() {
        //self.view.bringSubviewToFront(loadingView)
        //loadingView.isHidden = false
        //activityIndicator.isHidden = false
        //activityIndicator.startAnimating()
        ordersTableView.isHidden = true
        print("Start-Indicator")
    }
    
    func createIndicatorView() {
        //loadingView.isHidden = false
        //activityIndicator.isHidden = false
        //activityIndicator.startAnimating()
        ordersTableView.isHidden = true
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            //self.loadingView.isHidden = true
            //self.activityIndicator.isHidden = true
            //self.activityIndicator.stopAnimating()
            self.ordersTableView.isHidden = false
            self.ordersTableView.reloadData()
            
        }
    }
}
//All orders fetching structure for vendor orders
class AllOrders_vendor {
    static let shared = AllOrders_vendor()
    var allOrders: [VendorOrderData]
    private let saveKey = "AllOrders"
    
    var delegate: AllOrdersVendorFetchDelegate?
    let dispatchGroup = DispatchGroup()
    var dataFetched = false {
        didSet{
            if self.dataFetched{
                delegate?.allOrdersAreFetched()
            } else {
                delegate?.ordersCannotBeFetched()
            }
        }
    }
    var apiFetchError = false
    var jsonParseError = false
    
    init(){
        self.allOrders = []
    }
    
    func fetchAllOrders() {
        dispatchGroup.enter()
        APIManager().getVendorOrders(completionHandler: { orders in
            if orders != nil {
                
                self.dataFetched = true
                self.allOrders = orders!
                self.delegate?.allOrdersAreFetched()
                print("Fetched orders.")
            } else {
                self.dataFetched = false
                self.allOrders = []
                self.delegate?.ordersCannotBeFetched()
                print("Could not fetch orders.")
            }
        })
        dispatchGroup.leave()
        dispatchGroup.wait()
    }
        
}

protocol AllOrdersVendorFetchDelegate {
    func allOrdersAreFetched()
    func ordersCannotBeFetched()
}

