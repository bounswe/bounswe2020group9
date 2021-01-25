//
//  NotificationsViewController.swift
//  Bazaar-iOS
//
//  Created by Uysal, Sadi on 24.01.2021.
//

import UIKit
class NotificationsViewController: UIViewController{
    
    
    @IBOutlet weak var NotificationTableView: UITableView!
    var allNotificationsInstance = AllNotifications.shared
    var allProductsInstance = AllProducts.shared
    //var allOrdersInstance = AllOrders.shared
    var notifications:[Notification]=[]
    var products_dict: [Int: ProductData] = [:]
    var products: [ProductData] = []
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving orders", message: "We encountered a problem while retrieving the orders, please check your internet connection.", preferredStyle: .alert)
       
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
       allNotificationsInstance.delegate = self
        allProductsInstance.delegate = self
       let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
           // fetch orders
           self.allNotificationsInstance.fetchAllNotifications()
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
       if !(allNotificationsInstance.dataFetched) {
           print("orders not fetched yet,tryin to fetch right now")
           notificationsCannotBeFetched()
           self.allNotificationsInstance.fetchAllNotifications()
       }
       
   }
   
       
}

extension NotificationsViewController:UITableViewDelegate,UITableViewDataSource {
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
        cell.ImageView?.image = UIImage(named:"xmark.circle")
       //TODO change here
        let filteredNotifications:[Notification] = allNotificationsInstance.allNotifications
       let filteredProducts:[ProductData] = allProductsInstance.allProducts
       //let filteredVendors:[VendorData] = allVendorsInstance.allVendors
        let notification = filteredNotifications[indexPath.row]
       //print("Notifications count:" + String(filteredNotifications.count))
       print("Notifications ID: " + String(notification.id))
        //let order =
        //let product = products_dict[notification.]!                //filteredProducts[delivery.product_id]
       //let vendor = vendors_dict[delivery.vendor]!
       //let orderStatus=orderStatusArray[delivery.current_status]
       //cell.Cancel_OrderButton.tag = indexPath.row
       //cancel_button_delivery_id=delivery.id
       //cell.Cancel_OrderButton.addTarget(self, action: #selector(self.cancel_button_clicked(_:)), for: .allTouchEvents);
       
       cell.bodyLabel.text = notification.body
       cell.bodyLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
    if (notification.is_visited){
        cell.seenStatusLabel.text = "New notification"
        cell.seenStatusLabel.font = UIFont.systemFont(ofSize: 13, weight: .black)
    }else{
        cell.seenStatusLabel.text = "Seen"
        cell.seenStatusLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
    }
    
        cell.productNameLabel.text = "product.name"
       cell.productNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .black)
    
       
    cell.timeLabel.text = "Time : " + String(notification.timestamp.prefix(10))
    cell.timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
       
       print("complete setting order cell")
       
       
    print(cell.bodyLabel.text)
    print(cell.productNameLabel.text)
    print(cell.seenStatusLabel.text)
    /*
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
    }*/
       
       return cell
   }
   
}

extension NotificationsViewController: AllNotificationsFetchDelegate {
    func allNotificationsAreFetched() {
        self.stopIndicator()
        self.notifications = self.allNotificationsInstance.allNotifications
        self.NotificationTableView.reloadData()
    }
    
    func notificationsCannotBeFetched() {
        startIndicator()
    }
}





// MARK: - IndicatorView
extension NotificationsViewController {
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
extension NotificationsViewController: AllProductsFetchDelegate {
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
/*
extension NotificationsViewController: AllOrdersFetchDelegate {
    func allOrdersAreFetched() {
        self.stopIndicator()
        self.orders = self.allOrdersInstance.allOrders
    }
    
    func ordersCannotBeFetched() {
        startIndicator()
    }
}*/

class AllNotifications {
   static let shared = AllNotifications()
   var allNotifications: [Notification]
   private let saveKey = "AllNotifications"
   
   var delegate: AllNotificationsFetchDelegate?
   let dispatchGroup = DispatchGroup()
   var dataFetched = false {
       didSet{
           if self.dataFetched{
               delegate?.allNotificationsAreFetched()
           } else {
               delegate?.notificationsCannotBeFetched()
           }
       }
   }
   var apiFetchError = false
   var jsonParseError = false
   
   init(){
    self.allNotifications = []
   }
   
   func fetchAllNotifications() {
       dispatchGroup.enter()
       APIManager().getNotifications(completionHandler: { Notifications in
           if Notifications != nil {
               
               self.dataFetched = true
            self.allNotifications = Notifications!.notifications
               self.delegate?.allNotificationsAreFetched()
               print("Fetched notifications.")
           } else {
               self.dataFetched = false
               self.allNotifications = []
               self.delegate?.notificationsCannotBeFetched()
               print("Could not fetch notifications.")
           }
       })
       dispatchGroup.leave()
       dispatchGroup.wait()
   }
       
}

protocol AllNotificationsFetchDelegate {
   func allNotificationsAreFetched()
   func notificationsCannotBeFetched()
}




