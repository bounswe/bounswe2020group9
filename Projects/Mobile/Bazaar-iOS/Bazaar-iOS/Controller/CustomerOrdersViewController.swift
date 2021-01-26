//
//  CustomerOrdersViewController.swift
//  Bazaar-iOS
//
//  Created by Uysal, Sadi on 20.01.2021.
//

import UIKit

class CustomerOrdersViewController: UIViewController{
    

    @IBOutlet weak var ordersTableView: UITableView!
    var allOrdersInstance = AllOrders.shared
    
    var allProductsInstance = AllProducts.shared
    var allVendorsInstance = AllVendors.shared
    
    let orderStatusArray = ["", "Preparing", "On the Way", "Delivered", "Canceled"]
    
    var products_dict: [Int: ProductData] = [:]
    var vendors_dict: [Int: VendorData] = [:]
    
    var orders: [OrderData_Cust] = []
    var products: [ProductData] = []
    var vendors:[VendorData] = []
    
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving orders", message: "We encountered a problem while retrieving the orders, please check your internet connection.", preferredStyle: .alert)
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        ordersTableView.reloadData()
        ordersTableView.tableFooterView = UIView(frame: .zero)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
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
        if !(allOrdersInstance.dataFetched) {
            print("orders not fetched yet,tryin to fetch right now")
            ordersCannotBeFetched()
            self.allOrdersInstance.fetchAllOrders()
        }
        
    }
    
    
}

extension CustomerOrdersViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        print("returned order count")
        if tableView == ordersTableView {
            print(allOrdersInstance.allOrders.count)
            return allOrdersInstance.allOrders.count
        }else {
            print("Should not see this.")
            return 5
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("setting order cell : "+String(indexPath.row))
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "ReusableOrderCell", for: indexPath) as! OrderCell

        
        cell.ProductImage?.image = UIImage(named:"xmark.circle")
        //TODO change here
        let filteredOrders:[OrderData_Cust] = allOrdersInstance.allOrders
        //let filteredProducts:[ProductData] = allProductsInstance.allProducts
        //let filteredVendors:[VendorData] = allVendorsInstance.allVendors
        let order = filteredOrders[indexPath.row]
        print("Order deliveries count:" + String(order.deliveries.count))
        let delivery = order.deliveries[0]
        print("Product ID: " + String(delivery.product_id))
        let product = allProductsInstance.allProducts.filter{$0.id==delivery.product_id}[0]                //filteredProducts[delivery.product_id]
        //let vendor = vendors_dict[delivery.vendor]!
        let orderStatus=orderStatusArray[delivery.current_status]
        cell.delivery_id=delivery.id
        
        cell.Cancel_OrderButton.isHidden=true
        cell.Name_BrandLabel.text = product.name + " - " + product.brand//product.detail + ", " + 
        cell.Name_BrandLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        
        cell.Price_StatusLabel.text = "₺" + String(product.price) + ", Status: " + orderStatus
        cell.Price_StatusLabel.font = UIFont.systemFont(ofSize: 13, weight: .black)
        
        cell.VendorLabel.text = "Order deliveries count :" + String(order.deliveries.count-1)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let canceling_dId = self.orders[indexPath.row].id
        print(canceling_dId)
        print("hey")
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        let delete = UIContextualAction(style: .destructive, title: "Cancel") { (action, sourceView, completionHandler) in
            print("index path of cancel: \(indexPath)")
            completionHandler(true)
            DispatchQueue.main.async {
                APIManager().deleteOrder(delivery_id: canceling_dId, status: 4){ (result) in
                    switch result {
                    case .success(_):
                        alertController.message = "\(canceling_dId) is successfully deleted"
                        self.present(alertController, animated: true, completion: nil)
                        tableView.reloadData()
                    case .failure(_):
                        alertController.message = "\(canceling_dId) cannot be deleted"
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
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = ordersTableView.indexPathForSelectedRow
        let order_id = allOrdersInstance.allOrders[indexPath!.row].id
        if let detailResults = segue.destination as? OrderDetailViewController {
            detailResults.order_id = order_id
        }
    
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("HERE CLICKED")
        
        performSegue(withIdentifier: "orderToDetailSegue", sender: nil)
        
    }
    
    
    
    
    
    
}
extension CustomerOrdersViewController: AllProductsFetchDelegate {
    func allProductsAreFetched() {
        for prod in allProductsInstance.allProducts {
            products_dict[prod.id]=prod
            print("ADDED " + String(prod.id))
        }
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

extension CustomerOrdersViewController: AllVendorsFetchDelegate {
    func allVendorsAreFetched() {
        self.vendors = self.allVendorsInstance.allVendors
        for vendor in allVendorsInstance.allVendors {
            vendors_dict[vendor.id]=vendor
        }
        self.stopIndicator()
    }
    
    func vendorsCannotBeFetched() {
        startIndicator()
    }
}
extension CustomerOrdersViewController: AllOrdersFetchDelegate {
    func allOrdersAreFetched() {
        self.orders = self.allOrdersInstance.allOrders
        self.stopIndicator()
    }
    
    func ordersCannotBeFetched() {
        startIndicator()
    }
}


extension CustomerOrdersViewController:TableViewNewProtocol {
    func buttonClicked(index:Int) {
        print("Index:" + String(index))
        
        ordersTableView.reloadData()
    }
}


// MARK: - IndicatorView
extension CustomerOrdersViewController {
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

class AllOrders {
    static let shared = AllOrders()
    var allOrders: [OrderData_Cust]
    private let saveKey = "AllOrders"
    
    var delegate: AllOrdersFetchDelegate?
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
        APIManager().getCustomerOrders(completionHandler: { orders in
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

protocol AllOrdersFetchDelegate {
    func allOrdersAreFetched()
    func ordersCannotBeFetched()
}

