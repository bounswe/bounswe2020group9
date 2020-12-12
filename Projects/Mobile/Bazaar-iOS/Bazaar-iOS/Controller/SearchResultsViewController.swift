//
//  SearchResultsViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 7.12.2020.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    var searchWord:String!
    var isSearchWord: Bool!
    var isCategory: Bool!
    var isBrand: Bool!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var allProductsInstance = AllProducts.shared
    let categories = ["Clothing", "Home", "Selfcare", "Electronics", "Living"]
    var products: [ProductData] = []
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving products", message: "We encountered a problem while retrieving the products, please check your internet connection.", preferredStyle: .alert)
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setTitle()
        //searchResultsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allProductsInstance.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backItem?.title = ""
        //self.view.addSubview(searchResultsTableView)
        searchResultsTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
        createIndicatorView()
        searchResultsTableView.isHidden = false
        let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
            // fetch products
            self.allProductsInstance.fetchAllProducts()
        })
        networkFailedAlert.addAction(okButton)
        
        if !(allProductsInstance.dataFetched) {
            startIndicator()
            self.allProductsInstance.fetchAllProducts()
        }
        findProducts()
        searchResultsTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setTitle() {
        if (isSearchWord) {
            self.title = "Search Results for: \""+searchWord + "\""
        } else if (isCategory) {
            self.title = searchWord
        } else {
            self.title = searchWord
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
    }
    
    func findProducts() {
       if (isSearchWord) {
        products = allProductsInstance.allProducts.filter{$0.brand.contains(searchWord) || $0.name.contains(searchWord)}
       } else if (isCategory) {
        products = allProductsInstance.allProducts.filter{$0.category.parent!.contains(searchWord!) || $0.category.name.contains(searchWord!)}
       } else {
        products = allProductsInstance.allProducts.filter{$0.brand.contains(searchWord)}
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

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell", for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        cell.productDescriptionLabel.text = product.brand
        cell.productDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.productPriceLabel.text = String(product.price)
        cell.productPriceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        cell.productImageView.image = UIImage(named: "iphone12")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let product = products[indexPath.row]
            print(product.name)
        
    }
    
    
}

extension SearchResultsViewController: AllProductsFetchDelegate {
    func allProductsAreFetched() {
        stopIndicator()
        self.searchResultsTableView.reloadData()
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

extension SearchResultsViewController {
    func startIndicator() {
        self.view.bringSubviewToFront(loadingView)
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        searchResultsTableView.isHidden = true
    }

    func createIndicatorView() {
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        searchResultsTableView.isHidden = true
    }
    
    func stopIndicator() {
        //DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.view.sendSubviewToBack(self.loadingView)
            self.view.sendSubviewToBack(self.loadingView)
            self.searchResultsTableView.isHidden = false
            self.searchResultsTableView.isUserInteractionEnabled = true
            self.searchResultsTableView.reloadData()
        //}
    }
}


