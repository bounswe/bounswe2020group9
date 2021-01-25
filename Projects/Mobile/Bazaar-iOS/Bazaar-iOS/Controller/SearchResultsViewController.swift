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
    var isVendor: Bool!
    var searchResults:[ProductData] = []
    var filterType:String!
    var sortType:String!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var searchResultsEmptyLabel: UILabel!
    
    var allProductsInstance = AllProducts.shared
    let categories = ["Clothing", "Home", "Selfcare", "Electronics", "Living"]
    var products: [ProductData] = []
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving products", message: "We encountered a problem while retrieving the products, please check your internet connection.", preferredStyle: .alert)
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setTitle()
        fetchSearchResults(filterType: filterType, sortType: sortType)
        searchResultsTableView.reloadData()
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
        let retryButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
            // fetch products
            self.fetchSearchResults(filterType: "none", sortType: "none")
            self.allProductsInstance.fetchAllProducts()
        })
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        networkFailedAlert.addAction(okButton)
        networkFailedAlert.addAction(retryButton)
        
        if !(allProductsInstance.dataFetched) {
            startIndicator()
            self.allProductsInstance.fetchAllProducts()
        }
        if filterType == nil {
            filterType = "none"
        }
        if sortType == nil {
            sortType = "none"
        }
        startIndicator()
        fetchSearchResults(filterType: filterType, sortType: sortType)
        searchResultsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setTitle() {
        if (isSearchWord) {
            self.title = "Search Results for: \""+searchWord + "\""
        } else if (isCategory) {
            self.title = searchWord
        } else if (isBrand){
            self.title = searchWord
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
    }
    
    func fetchSearchResults(filterType:String, sortType:String) {
        if (isCategory) {
            self.searchResultsTableView.isHidden = true
            self.products = allProductsInstance.allProducts.filter{$0.category.parent.lowercased().contains(searchWord!.lowercased()) || $0.category.name.lowercased().contains(searchWord!.lowercased())}
            if filterType != "none" {
                let filters = filterType.split(separator: "&")
                let filtersValues = filters.map {$0.split(separator: "=")}
                for filter in filtersValues {
                    print("... ", filter)
                    if filter[0] == "pr" {
                        self.products = self.products.filter {$0.rating >= Double(filter[1])!}
                    } else if filter[0] == "prc" {
                        print("1")
                        let priceRange = filter[1].split(separator: "-")
                        print(priceRange[0], priceRange[1])
                        self.products = self.products.filter {(Int($0.price.rounded(.down)) >= Int(priceRange[0])!) && (Int($0.price.rounded(.down)) <= Int(priceRange[1])!)}
                    } else if filter[0] == "br" {
                        self.products = self.products.filter{$0.brand.lowercased() == filter[1].lowercased()}
                    }
                }
            }
            
            if sortType == "bs" {
                self.products = self.products.sorted(by: {$0.sell_counter > $1.sell_counter})
            } else if sortType == "mf" {
                self.products = self.products.sorted(by: {$0.rating > $1.rating})
            } else if sortType == "pr_des" {
                self.products = self.products.sorted(by: {$0.price > $1.price})
            } else if sortType == "pr_asc" {
                self.products = self.products.sorted(by: {$0.price < $1.price})
            }
            if(self.products.count == 0) {
                self.searchResultsTableView.isHidden = true
                self.searchResultsEmptyLabel.isHidden = false
            } else {
                self.searchResultsTableView.isHidden = false
                self.searchResultsEmptyLabel.isHidden = true
                self.searchResultsTableView.reloadData()
            }
            self.searchResultsTableView.reloadData()
            self.searchResultsTableView.isHidden = false
            DispatchQueue.main.async {
                self.stopIndicator()
            }
        /*} else if (isBrand) {
            self.searchResultsTableView.isHidden = true
            self.products = allProductsInstance.allProducts.filter{$0.brand.lowercased() == searchWord.lowercased()}
            self.searchResultsTableView.reloadData()
            DispatchQueue.main.async {
                self.stopIndicator()
            }
            self.searchResultsTableView.isHidden = false */
        } else if (isBrand){
            self.searchResultsTableView.isHidden = true
            self.products = allProductsInstance.allProducts.filter{$0.brand.lowercased().contains(searchWord!.lowercased())}
            if filterType != "none" {
                let filters = filterType.split(separator: "&")
                let filtersValues = filters.map {$0.split(separator: "=")}
                for filter in filtersValues {
                    print("... ", filter)
                    if filter[0] == "pr" {
                        self.products = self.products.filter {$0.rating >= Double(filter[1])!}
                    } else if filter[0] == "prc" {
                        print("1")
                        let priceRange = filter[1].split(separator: "-")
                        print(priceRange[0], priceRange[1])
                        self.products = self.products.filter {(Int($0.price.rounded(.down)) >= Int(priceRange[0])!) && (Int($0.price.rounded(.down)) <= Int(priceRange[1])!)}
                    } else if filter[0] == "br" {
                        self.products = self.products.filter{$0.brand.lowercased() == filter[1].lowercased()}
                    }
                }
            }
            
            if sortType == "bs" {
                self.products = self.products.sorted(by: {$0.sell_counter > $1.sell_counter})
            } else if sortType == "mf" {
                self.products = self.products.sorted(by: {$0.rating > $1.rating})
            } else if sortType == "pr_des" {
                self.products = self.products.sorted(by: {$0.price > $1.price})
            } else if sortType == "pr_asc" {
                self.products = self.products.sorted(by: {$0.price < $1.price})
            }
            if(self.products.count == 0) {
                self.searchResultsTableView.isHidden = true
                self.searchResultsEmptyLabel.isHidden = false
            } else {
                self.searchResultsTableView.isHidden = false
                self.searchResultsEmptyLabel.isHidden = true
                self.searchResultsTableView.reloadData()
            }
            self.searchResultsTableView.reloadData()
            self.searchResultsTableView.isHidden = false
            DispatchQueue.main.async {
                self.stopIndicator()
            }
        } else {
            self.searchResultsTableView.isHidden = true
            APIManager().search(filterType: filterType, sortType: sortType, searchWord: searchWord, completionHandler: { result in
                switch result {
                case .success(let searchResultList):
                    DispatchQueue.main.async {
                        /*let searchResultIDs = searchResultList.product_list.map{$0.id}
                        self.products = []
                        for id in searchResultIDs {
                            if self.allProductsInstance.allProducts.filter({$0.id == id}).count > 0 {
                                self.products.append(self.allProductsInstance.allProducts.filter{$0.id == id}[0])
                            }
                        }*/
                        self.products = searchResultList.product_list ?? []
                        //self.products = self.allProductsInstance.allProducts.filter{searchResultIDs.contains($0.id)}
                        if(self.products.count == 0) {
                            self.searchResultsTableView.isHidden = true
                            self.searchResultsEmptyLabel.isHidden = false
                        } else {
                            self.searchResultsTableView.isHidden = false
                            self.searchResultsEmptyLabel.isHidden = true
                            self.searchResultsTableView.reloadData()
                        }
                    }
                case .failure(let err):
                    DispatchQueue.main.async {
                        self.products = []
                        print(err)
                        self.networkFailedAlert.message = "Search results cannot be retrieved due to a network problem. Please try again later."
                        
                        self.present(self.networkFailedAlert, animated:true, completion: nil /*{
                                     self.fetchSearchResults(filterType: self.filterType, sortType: self.sortType)
                                     }*/)
                    }
                }
                self.stopIndicator()
                self.searchResultsTableView.reloadData()
            })
        }
        self.stopIndicator()
        self.searchResultsTableView.reloadData()
    }
    
    /*func findProducts() {
       if (isSearchWord) {
        products = allProductsInstance.allProducts.filter{$0.brand.contains(searchWord) || $0.name.contains(searchWord)}
       } else if (isCategory) {
        products = allProductsInstance.allProducts.filter{$0.category.parent!.contains(searchWord!) || $0.category.name.contains(searchWord!)}
       } else {
        products = allProductsInstance.allProducts.filter{$0.brand.contains(searchWord)}
       }
    }*/
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let productDetailVC = segue.destination as? ProductDetailViewController {
            let indexPath =  self.searchResultsTableView.indexPathForSelectedRow
            if indexPath != nil {
                productDetailVC.product = products[indexPath!.row]
            }
        }
        if let filterVC = segue.destination as? FilterViewController {
            filterVC.delegate = self
        }
    }
    

}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell", for: indexPath) as! ProductCell
        cell.productImageView?.image = UIImage(named:"xmark.circle")
        let product = products[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        cell.productDescriptionLabel.text = product.brand
        cell.productDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.productPriceLabel.text = "₺\(product.price)"
        cell.productPriceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        //cell.productImageView.image = UIImage(named: "iphone12")
        /*if let url = product.picture {
            do{
                try cell.productImageView.loadImageUsingCache(withUrl: url)
                cell.productImageView.contentMode = .scaleAspectFit
            } catch let error {
                print(error)
                cell.productImageView.image = UIImage(named:"xmark.circle")
                cell.productImageView.tintColor = UIColor.lightGray
                cell.productImageView.contentMode = .scaleAspectFit
            }
        } else {
            cell.productImageView.image = UIImage(named:"xmark.circle")
            cell.productImageView.tintColor = UIColor.lightGray
            cell.productImageView.contentMode = .scaleAspectFit
        }*/
        if allProductsInstance.allImages.keys.contains(product.id) {
            cell.productImageView.image = allProductsInstance.allImages[product.id]
            cell.productImageView.contentMode = .scaleAspectFit
        } else {
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
            }  else {
                cell.productImageView.image = UIImage(named:"xmark.circle")
                cell.productImageView.tintColor = UIColor.lightGray
                cell.productImageView.contentMode = .center
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "searchResultsToProductDetailSegue", sender: nil)
    }
    
    
}

extension SearchResultsViewController: FilterViewControllerDelegate {
    func filterViewControllerResponse(filterStr: String, sortStr: String) {
        self.filterType = filterStr
        self.sortType = sortStr
        self.fetchSearchResults(filterType: self.filterType, sortType: self.filterType)
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
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.searchResultsTableView.isHidden = true
        }
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
            self.searchResultsTableView.isHidden = false
            self.searchResultsTableView.isUserInteractionEnabled = true
            self.searchResultsTableView.reloadData()
        //}
    }
}


