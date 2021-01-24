//
//  NotificationsViewController.swift
//  Bazaar-iOS
//
//  Created by Uysal, Sadi on 24.01.2021.
//

import UIKit
class NotificationsViewController: UIViewController{
    
    
    @IBOutlet weak var NotificationTableView: UITableView!
    var allOrdersInstance = AllNotifications.shared
    var notifications:[NotificationsData]=[]
  
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
       allOrdersInstance.delegate = self
       let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
           // fetch orders
           self.allOrdersInstance.fetchAllNotifications()
       })
       networkFailedAlert.addAction(okButton)
       NotificationTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "ReusableOrderCell")
       if !(allOrdersInstance.dataFetched) {
           print("orders not fetched yet,tryin to fetch right now")
           notificationsCannotBeFetched()
           self.allOrdersInstance.fetchAllNotifications()
       }
       
   }
   
       
}

   extension NotificationsViewController:UITableViewDelegate,UITableViewDataSource {
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           //return 10
           print("returned order count")
           if tableView == NotificationTableView {
               print(allOrdersInstance.allOrders.count)
               return allOrdersInstance.allOrders.count
           }else {
               print("Should not see this.")
               return 5
           }
       }
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
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           print("setting order cell : "+String(indexPath.row))
           let cell = NotificationTableView.dequeueReusableCell(withIdentifier: "ReusableOrderCell", for: indexPath) as! OrderCell
           cell.ProductImage?.image = UIImage(named:"xmark.circle")
           //TODO change here
           let filteredOrders:[NotificationsData] = allOrdersInstance.allOrders
           //let filteredProducts:[ProductData] = allProductsInstance.allProducts
           //let filteredVendors:[VendorData] = allVendorsInstance.allVendors
           let order = filteredOrders[indexPath.row]
           //print("Order deliveries count:" + String(order.deliveries.count))
           let delivery = order
           print("Product ID: " + String(delivery.product_id))
           let product = products_dict[delivery.product_id]!                //filteredProducts[delivery.product_id]
           //let vendor = vendors_dict[delivery.vendor]!
           let orderStatus=orderStatusArray[delivery.current_status]
           cell.Cancel_OrderButton.tag = indexPath.row
           cancel_button_delivery_id=delivery.id
           cell.Cancel_OrderButton.addTarget(self, action: #selector(self.cancel_button_clicked(_:)), for: .allTouchEvents);
           
           cell.Name_BrandLabel.text = product.detail + ", " + product.brand
           cell.Name_BrandLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
           
           cell.Price_StatusLabel.text = "₺" + String(product.price) + ", Status: " + orderStatus
           cell.Price_StatusLabel.font = UIFont.systemFont(ofSize: 13, weight: .black)
           cell.VendorLabel.text = "Order Date: " + delivery.timestamp.prefix(10)
           cell.VendorLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           cell.AmountLabel.text = "Amount : " + String(delivery.amount)
           cell.AmountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           cell.DatesLabel.text = "Estimated Delivery : " + delivery.delivery_time.prefix(10)
           cell.DatesLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
           cell.AdressLabel.text = "Order Adress: " + delivery.delivery_address.address + delivery.delivery_address.city
           cell.AdressLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
           print("complete setting order cell")
           
           
           print(cell.Name_BrandLabel.text)
           print(cell.Price_StatusLabel.text)
           print(cell.VendorLabel.text)
           print(cell.AmountLabel.text)
           print(cell.DatesLabel.text)
           print(cell.AdressLabel.text)
           
           
           return cell
       }
       
   }

    extension NotificationsViewController: AllNotificationsFetchDelegate {
        func allNotificationsAreFetched() {
            self.stopIndicator()
            self.notifications = self.allOrdersInstance.allOrders
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

   class AllNotifications {
       static let shared = AllNotifications()
       var allOrders: [NotificationsData]
       private let saveKey = "AllOrders"
       
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
           self.allOrders = []
       }
       
       func fetchAllNotifications() {
           dispatchGroup.enter()
           APIManager().getNotifications(completionHandler: { orders in
               if orders != nil {
                   
                   self.dataFetched = true
                   self.allOrders = orders!
                   self.delegate?.allNotificationsAreFetched()
                   print("Fetched notifications.")
               } else {
                   self.dataFetched = false
                   self.allOrders = []
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
    
    


