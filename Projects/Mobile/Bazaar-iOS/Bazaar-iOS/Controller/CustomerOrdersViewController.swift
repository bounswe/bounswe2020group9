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
    var selectedCategoryName: String? //look again
    var orders: [Product] = []
    
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving orders", message: "We encountered a problem while retrieving the orders, please check your internet connection.", preferredStyle: .alert)
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        ordersTableView.reloadData()
        ordersTableView.tableFooterView = UIView(frame: .zero)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //searchResults = searchHistory
        //searchBar.searchTextField.text = ""
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCategoryName = "Clothing"
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        allOrdersInstance.delegate = self
        let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
            // fetch orders
            self.allOrdersInstance.fetchAllOrders()
        })
        networkFailedAlert.addAction(okButton)
        ordersTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
        if !(allOrdersInstance.dataFetched) {
            //startIndicator()
            self.allOrdersInstance.fetchAllOrders()
        }
        
    }
    
   /*
    func categorySelected () {
        self.ordersTableView.reloadData()
    }*/
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dismiss(animated: true, completion: nil)
        /*
        if let productDetailVC = segue.destination as? ProductDetailViewController {
            let indexPath = self.ordersTableView.indexPathForSelectedRow
            if indexPath != nil {
                let orders = allOrdersInstance.AllOrders.filter{$0.category.parent!.contains(selectedCategoryName!) || $0.category.name.contains(selectedCategoryName!)}
                productDetailVC.product = orders[indexPath!.row]
            }
        } else if let vendorProfileVC = segue.destination as? VendorProfileForUserViewController {
            let indexPath = self.ordersTableView.indexPathForSelectedRow
            if indexPath != nil {
                let vendor = allVendorsInstance.allVendors.filter{$0.company.contains(searchResults[indexPath!.row])}
                vendorProfileVC.vendor = vendor[0]
            }
        }*/
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        /*
        if identifier == "mainToProductDetailSegue" {
             return self.ordersTableView.indexPathForSelectedRow != nil
        } else if identifier == "mainToVendorProfileSegue" {
            return !(searchTextField?.text == "")
        }*/
        return false
    }


}

extension CustomerOrdersViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        if tableView == ordersTableView {
            return allOrdersInstance.All_Orders.filter{($0.category.parent?.contains(selectedCategoryName!))! || $0.category.name.contains(selectedCategoryName!)}.count
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell", for: indexPath) as! ProductCell
        cell.productImageView?.image = UIImage(named:"xmark.circle")
        let filteredorders:[ProductData] = allOrdersInstance.All_Orders.filter{($0.category.parent?.contains(selectedCategoryName!))! || $0.category.name.contains(selectedCategoryName!)}
        let product = filteredorders[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        cell.productDescriptionLabel.text = product.brand
        cell.productDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.productPriceLabel.text = "₺"+String(product.price)
        cell.productPriceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        if allOrdersInstance.allImages.keys.contains(product.id) {
            cell.productImageView.image = allOrdersInstance.allImages[product.id]
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filteredorders:[ProductData] = allOrdersInstance.All_Orders.filter{($0.category.parent?.contains(selectedCategoryName!))! || $0.category.name.contains(selectedCategoryName!)}
        let product = filteredorders[indexPath.row]
        print(product.name)
        performSegue(withIdentifier: "mainToProductDetailSegue", sender: nil)
        
    }
    
}




extension CustomerOrdersViewController: AllOrdersFetchDelegate {
    func AllOrdersAreFetched() {
        self.stopIndicator()
        self.ordersTableView.reloadData()
    }
    
    func ordersCannotBeFetched() {
        startIndicator()
        presentAlert()
        
    }
    
    func presentAlert() {
        if allOrdersInstance.apiFetchError {
            self.networkFailedAlert.message = "We couldn't connect to the network, please check your internet connection."
        }
        if allOrdersInstance.jsonParseError {
            self.networkFailedAlert.message = "There is an internal problem in the system."
        }
        if !self.networkFailedAlert.isBeingPresented {
            self.present(networkFailedAlert, animated:true, completion: nil)
        }
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
            self.ordersTableView.isUserInteractionEnabled = true
            self.ordersTableView.reloadData()
            
        }
    }
}

protocol AllOrdersFetchDelegate {
    func AllOrdersAreFetched()
    func ordersCannotBeFetched()
    func presentAlert()
}

class AllOrders {
    static let shared = AllOrders()
    var All_Orders: [ProductData]
    var allImages: Dictionary<Int, UIImage>
    var allImageNames: [String]
    private let saveKey = "AllOrders"
    
    var delegate: AllOrdersFetchDelegate?
    let dispatchGroup = DispatchGroup()
    var dataFetched = false {
        didSet{
            if self.dataFetched{
                delegate?.AllOrdersAreFetched()
            } else {
                delegate?.ordersCannotBeFetched()
            }
        }
    }
    var apiFetchError = false
    var jsonParseError = false
    
    init(){
        self.All_Orders = []
        self.allImages = Dictionary()
        self.allImageNames = []
    }
    
    func fetchAllOrders() {
        dispatchGroup.enter()
        APIManager().getAllProducts(completionHandler: { orders in
            if orders != nil {
                self.dataFetched = true
                self.All_Orders = orders!
                let group = DispatchGroup()
                let serialQueue = DispatchQueue(label: "serialQueue")
                for prod in self.All_Orders {
                    group.enter()
                    if let pic = prod.picture {
                        print(prod.name, pic)
                        let url = URL(string: prod.picture!)
                        URLSession(configuration: .default).dataTask(with: url!) { (data, response, error) in
                            guard let data = data, let image = UIImage(data: data), error == nil else { group.leave(); return }
                            
                            // ***************************************************************************
                            // creates a synchronized access to the images array
                            serialQueue.async {
                                self.allImages[prod.id] = image
                                
                                // ****************************************************
                                // tells the group a pending process has been completed
                                print(prod.id, "done")
                                group.leave()
                            }
                        }.resume()
                    } else {
                        group.leave()
                    }
                    
                }
                group.wait()
                self.delegate?.AllOrdersAreFetched()
            } else {
                self.dataFetched = false
                self.All_Orders = []
                self.delegate?.ordersCannotBeFetched()
            }
        })
        dispatchGroup.leave()
        dispatchGroup.wait()
    }
        
}

