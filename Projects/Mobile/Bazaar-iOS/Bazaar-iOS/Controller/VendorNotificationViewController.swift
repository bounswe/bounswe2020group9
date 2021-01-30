//
//  VendorNotificationViewController.swift
//  Bazaar-iOS
//
//  Created by Uysal, Sadi on 25.01.2021.
//

import UIKit
import DropDown
class VendorNotificationViewController: UIViewController{
    
    @IBOutlet weak var NotificationTableView: UITableView!
    var allNotificationsInstance = AllNotifications.shared
    var allProductsInstance = AllProducts.shared
    var allOrdersInstance = AllOrders_vendor.shared
    
    var orders_dict:[Int: VendorOrderData] = [:]
    var products_dict: [Int: ProductData] = [:]
    
    var notifications:[Notification]=[]
    var orders: [VendorOrderData] = []
    var products: [ProductData] = []
    
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving notification", message: "We encountered a problem while retrieving the notification, please check your internet connection.", preferredStyle: .alert)
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationTableView.reloadData()
        NotificationTableView.tableFooterView = UIView(frame: .zero)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationTableView.dataSource = self
        NotificationTableView.delegate = self
        allNotificationsInstance.delegate = self
        allProductsInstance.delegate = self
        allOrdersInstance.delegate = self
        let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
            // fetch orders
            self.allProductsInstance.fetchAllProducts()
            self.allNotificationsInstance.fetchAllNotifications()
            self.allOrdersInstance.fetchAllOrders()
        })
        networkFailedAlert.addAction(okButton)
        NotificationTableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "ReusableNotfCell")
        if !(allProductsInstance.dataFetched) {
            print("products not fetched yet,tryin to fetch right now")
            productsCannotBeFetched()
            self.allProductsInstance.fetchAllProducts()
        }else {
            for prod in allProductsInstance.allProducts {
                products_dict[prod.id]=prod
            }
        }
        if !(allOrdersInstance.dataFetched) {
            print("orders not fetched yet,tryin to fetch right now")
            ordersCannotBeFetched()
            self.allOrdersInstance.fetchAllOrders()
        }else {
            for order in allOrdersInstance.allOrders {
                orders_dict[order.id]=order
            }
        }
        self.allNotificationsInstance.fetchAllNotifications()
        if !(allNotificationsInstance.dataFetched) {
            print("notification not fetched yet,tryin to fetch right now")
            notificationsCannotBeFetched()
            self.allNotificationsInstance.fetchAllNotifications()
        }
        
    }
    
    
}

extension VendorNotificationViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        print("returned notification count")
        if tableView == NotificationTableView {
            print(allNotificationsInstance.allNotifications.count)
            return allNotificationsInstance.allNotifications.count
        }else {
            print("Should not see this.")
            return 5
        }
    }
    /*
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
     }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("setting notification cell : "+String(indexPath.row))
        let cell = NotificationTableView.dequeueReusableCell(withIdentifier: "ReusableNotfCell", for: indexPath) as! NotificationCell
        
        //cell.ImageView?.image = UIImage(named:"xmark.circle")
        //TODO change here
        //let filteredNotifications:[Notification] = allNotificationsInstance.allNotifications
        let filteredProducts:[ProductData] = allProductsInstance.allProducts
        //let filteredVendors:[VendorData] = allVendorsInstance.allVendors
        let notification = allNotificationsInstance.allNotifications.sorted(by: { $0.id > $1.id })[indexPath.row]
        print("Notifications count:" + String(allNotificationsInstance.allNotifications.count))
        print("Notifications ID: " + String(notification.id))
        let notf_id=notification.id
        let notf_body=notification.body
        let notf_time=notification.timestamp.prefix(10)
        let notf_isVisited=notification.is_visited
        let notf_userId=notification.user
        
        let product=allProductsInstance.allProducts.filter{$0.id == notification.delivery[0].product_id}[0]
        //let product=products_dict[product_id]
        
        //cell.Cancel_OrderButton.tag = indexPath.row
        //cancel_button_delivery_id=delivery.id
        //cell.Cancel_OrderButton.addTarget(self, action: #selector(self.cancel_button_clicked(_:)), for: .allTouchEvents);
        
        if (!notf_isVisited){
            cell.bodyLabel.text = notf_body
            cell.bodyLabel.font = UIFont.systemFont(ofSize: 10, weight: .black)
            cell.seenStatusLabel.text = "New notification"
            cell.seenStatusLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
            cell.productNameLabel.text = product.name
            cell.productNameLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.timeLabel.text = "Time : " + notf_time
            cell.timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .black)
        }else{
            cell.bodyLabel.text = notf_body
            cell.bodyLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.seenStatusLabel.text = "Seen"
            cell.seenStatusLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            cell.productNameLabel.text = product.name
            cell.productNameLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.timeLabel.text = "Time : " + notf_time
            cell.timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        }
        
        
        print("complete setting notification cell")
        if allProductsInstance.allImages.keys.contains(product.id) {
            cell.ImageView.image = allProductsInstance.allImages[product.id]
            cell.ImageView.contentMode = .scaleAspectFit
            print("1: Name: \(product.name) :Product ID: \(product.id)")
         } else {
            print("2: \(product.name)")
            if let url = product.picture {
                do{
                    try cell.ImageView.loadImageUsingCache(withUrl: url, forProduct: product)
                    cell.ImageView.contentMode = .scaleAspectFit
                 } catch let error {
                     print(error)
                     //cell.ImageView.image = UIImage(named:"xmark.circle")
                     cell.ImageView.tintColor = UIColor.lightGray
                     cell.ImageView.contentMode = .center
                 }
             }
         }
        
        return cell
    }
    
}

extension VendorNotificationViewController: AllNotificationsFetchDelegate {
    func allNotificationsAreFetched() {
        self.stopIndicator()
        self.notifications = self.allNotificationsInstance.allNotifications.sorted(by: { $0.id > $1.id })
        self.NotificationTableView.reloadData()
    }
    
    func notificationsCannotBeFetched() {
        startIndicator()
    }
}
extension VendorNotificationViewController: AllProductsFetchDelegate {
    func allProductsAreFetched() {
        for prod in allProductsInstance.allProducts {
            products_dict[prod.id]=prod
            print("ADDED " + String(prod.id))
        }
        self.stopIndicator()
        self.NotificationTableView.reloadData()
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
extension VendorNotificationViewController: AllOrdersVendorFetchDelegate {
    func allOrdersAreFetched() {
        self.stopIndicator()
        self.orders = self.allOrdersInstance.allOrders
        for order in allOrdersInstance.allOrders {
            orders_dict[order.id]=order
        }
        self.NotificationTableView.reloadData()
    }
    
    func ordersCannotBeFetched() {
        startIndicator()
    }
}





// MARK: - IndicatorView
extension VendorNotificationViewController {
    func startIndicator() {
        //self.view.bringSubviewToFront(loadingView)
        //loadingView.isHidden = false
        //activityIndicator.isHidden = false
        //activityIndicator.startAnimating()
        NotificationTableView.isHidden = true
        print("Start-Indicator")
    }
    
    func createIndicatorView() {
        //loadingView.isHidden = false
        //activityIndicator.isHidden = false
        //activityIndicator.startAnimating()
        NotificationTableView.isHidden = true
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            //self.loadingView.isHidden = true
            //self.activityIndicator.isHidden = true
            //self.activityIndicator.stopAnimating()
            self.NotificationTableView.isHidden = false
            self.NotificationTableView.reloadData()
            
        }
    }
}

