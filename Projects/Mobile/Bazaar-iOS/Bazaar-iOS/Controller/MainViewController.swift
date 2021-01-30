//
//  ViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 8.11.2020.
//

import UIKit

class MainViewController: UIViewController{

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchHistoryTableView: UITableView!
    
    
    var allProductsInstance = AllProducts.shared
    var allVendorsInstance = AllVendors.shared
    var selectedCategoryName: String?
    var recommendations:[ProductData] = []
    var recommendationsFetched = false

    var selectedCategoryButton: UIButton? {
        didSet{
            selectedCategoryName = selectedCategoryButton?.titleLabel?.text
            categorySelected()
        }
    }
    
    let CLOTHING = "Clothing"
    let HOME = "Home"
    let BEAUTY = "Beauty"
    let ELECTRONICS = "Electronics"
    let LIVING = "Living"
    
    let categories = ["Clothing", "Home", "Selfcare", "Electronics", "Living"]
    var products: [Product] = []
    var vendors:[VendorData] = []
    let categoriesReuseIdentifier = "CategoriesCollectionViewCell"
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving products", message: "We encountered a problem while retrieving the products, please check your internet connection.", preferredStyle: .alert)
    var searchHistory:[String] = (UserDefaults.standard.value(forKey: K.searchHistoryKey) as? [String] ?? [])
    var searchResults:[String] = []
    var historyEndIndex:Int = 0
    var categoriesEndIndex: Int = 0
    var brandsEndIndex: Int = 0
    var searchTextField: UITextField?
    
    /*
     function that is automatically called every time before the view will appear on screen
     */
    override func viewWillAppear(_ animated: Bool) {
        searchHistoryTableView.reloadData()
        productTableView.reloadData()
        if #available(iOS 13.0, *) {
            searchTextField = searchBar.searchTextField
        } else {
            self.searchBar.barStyle = .default
            if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                searchTextField = searchField
            }
        }
        DispatchQueue.global(qos: .background).async {
            APIManager().getAllProducts(completionHandler: { products in
                if let prodlist = products {
                    DispatchQueue.main.async {
                        self.allProductsInstance.allProducts = prodlist
                    }
                }
            })
            APIManager().getAllVendors(str: "", completionHandler: { result in
                switch result {
                case .success(let vendors):
                    DispatchQueue.main.async {
                        self.allVendorsInstance.allVendors = vendors
                    }
                case .failure(let err):
                    print(err)
                }
                
            })
        }
        searchTextField?.alpha = 1.0
        searchResults = searchHistory
        historyEndIndex = searchHistory.count
        categoriesEndIndex = searchHistory.count
        brandsEndIndex = searchHistory.count
        productTableView.tableFooterView = UIView(frame: .zero)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /*
     function that is automatically called every time before the view will disappear from screen.
     */
    override func viewWillDisappear(_ animated: Bool) {
        searchResults = searchHistory
        searchBar.searchTextField.text = ""
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /*
     function that is automatically called when the view first appears on screen.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        productTableView.dataSource = self
        productTableView.delegate = self
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        allProductsInstance.delegate = self
        allVendorsInstance.delegate = self
        searchHistoryTableView.isHidden = true
        self.view.sendSubviewToBack(searchHistoryTableView)
        self.view.sendSubviewToBack(searchHistoryTableView)
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier:  "CategoryCollectionViewCell")
        createIndicatorView()
        let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
            // fetch products
            self.allProductsInstance.fetchAllProducts()
        })
        networkFailedAlert.addAction(okButton)
        selectedCategoryName = CLOTHING
        productTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
        if !(allProductsInstance.dataFetched) {
            self.searchBar.resignFirstResponder()
            self.searchBar.isUserInteractionEnabled = false
            startIndicator()
            self.allProductsInstance.fetchAllProducts()
        }

        searchResults = searchHistory
        historyEndIndex = searchHistory.count
        
    }
    
    
    /*
     function that reloads the products of the tableview when a category is selected.
     */
    func categorySelected () {
        self.productTableView.reloadData()
    }
    
    
    // MARK: - Navigation
    /*
     function that is automatically called before performing a segue from this view.
     used for passing the values to the next view controller.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.searchBar.showsCancelButton = false
        
        searchHistoryTableView.isHidden = true
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        self.view.sendSubviewToBack(searchHistoryTableView)
        self.view.sendSubviewToBack(searchHistoryTableView)
        if let searchResultsVC = segue.destination as? SearchResultsViewController {
            searchResultsVC.searchWord = searchTextField!.text ?? ""
            let indexpath = searchHistoryTableView.indexPathForSelectedRow
            if indexpath != nil {
                searchResultsVC.filterType = "none"
                searchResultsVC.sortType = "none"
                if indexpath!.row < historyEndIndex {
                    searchResultsVC.isSearchWord = true
                    searchResultsVC.isBrand = false
                    searchResultsVC.isCategory = false
                } else if indexpath!.row < categoriesEndIndex {
                    searchResultsVC.isSearchWord = false
                    searchResultsVC.isBrand = false
                    searchResultsVC.isCategory = true
                } else if indexpath!.row < brandsEndIndex {
                    searchResultsVC.isSearchWord = false
                    searchResultsVC.isBrand = true
                    searchResultsVC.isCategory = false
                } else {
                    // send to vendor profile
                }
            } else {
                searchResultsVC.isSearchWord = true
                searchResultsVC.isBrand = false
                searchResultsVC.isCategory = false
            }
            
            searchBar.text = ""
        } else if let productDetailVC = segue.destination as? ProductDetailViewController {
            let indexPath = self.productTableView.indexPathForSelectedRow
            if indexPath != nil {
                let products = allProductsInstance.allProducts.filter{$0.category.parent.contains(selectedCategoryName!) || $0.category.name.contains(selectedCategoryName!)}
                productDetailVC.product = products[indexPath!.row]
            }
        } else if let vendorProfileVC = segue.destination as? VendorProfileForUserViewController {
            let indexPath = self.searchHistoryTableView.indexPathForSelectedRow
            if indexPath != nil {
                let vendor = allVendorsInstance.allVendors.filter{$0.company.contains(searchResults[indexPath!.row])}
                vendorProfileVC.vendor = vendor[0]
            }
        }
    }
    
    /*
     function that decides if a segue from this view controller to another should be performed or not.
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "mainToSearchResultsSegue" {
            return !(searchTextField?.text == "")
        } else if identifier == "mainToProductDetailSegue" {
             return self.productTableView.indexPathForSelectedRow != nil
        } else if identifier == "mainToVendorProfileSegue" {
            return !(searchTextField?.text == "")
        }
        return false
    }
}

extension MainViewController:UITableViewDelegate,UITableViewDataSource {
    /*
     function that sets the number of rows in a tableview.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productTableView {
            if recommendationsFetched {
                if (recommendations.filter{($0.category.parent.contains(selectedCategoryName!)) || $0.category.name.contains(selectedCategoryName!)}.count > 1) {
                    return recommendations.filter{($0.category.parent.contains(selectedCategoryName!)) || $0.category.name.contains(selectedCategoryName!)}.count
                } else {
                    return allProductsInstance.allProducts.filter{($0.category.parent.contains(selectedCategoryName!)) || $0.category.name.contains(selectedCategoryName!)}.count
                }
            } else {
                return allProductsInstance.allProducts.filter{($0.category.parent.contains(selectedCategoryName!)) || $0.category.name.contains(selectedCategoryName!)}.count
            }
            
        }
        if tableView == searchHistoryTableView {
            return searchResults.count
        }
        return 10
    }
    
    /*
     function that is called for filling out the data of a UITableViewCell while it's rendered
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == productTableView {
            let cell = productTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell", for: indexPath) as! ProductCell
            cell.productImageView?.image = UIImage(named:"xmark.circle")
            var filteredProducts:[ProductData] = allProductsInstance.allProducts.filter{($0.category.parent.contains(selectedCategoryName!)) || $0.category.name.contains(selectedCategoryName!)}
            if recommendationsFetched {
                filteredProducts = recommendations.filter{($0.category.parent.contains(selectedCategoryName!)) || $0.category.name.contains(selectedCategoryName!)}
                if filteredProducts.count < 1 {
                    recommendationsFetched = false
                    filteredProducts = allProductsInstance.allProducts.filter{($0.category.parent.contains(selectedCategoryName!)) || $0.category.name.contains(selectedCategoryName!)}
                }
            }
            let product = filteredProducts[indexPath.row]
            cell.productNameLabel.text = product.name
            cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
            cell.productDescriptionLabel.text = product.brand
            cell.productDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            cell.productPriceLabel.text = "₺"+String(product.price) 
            cell.productPriceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            
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
        } else {
            let cell = searchHistoryTableView.dequeueReusableCell(withIdentifier: "searchHistoryCell", for: indexPath) as! SearchHistoryTableViewCell
            cell.resultLabel.text = searchResults[indexPath.row]
            if indexPath.row < historyEndIndex {
                cell.showClock()
                cell.hideType()
            } else if indexPath.row < categoriesEndIndex {
                cell.hideClock()
                cell.showType()
                cell.typeLabel.text = "Category"
            } else if indexPath.row < brandsEndIndex {
                cell.hideClock()
                cell.showType()
                cell.typeLabel.text = "Brand"
            } else {
                cell.hideClock()
                cell.showType()
                cell.typeLabel.text = "Vendor"
            }
            return cell
        }
    }
    
    /*
     function that is called when a UITableViewCell is selected via clicking.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchHistoryTableView {
            searchTextField?.text = searchResults[indexPath.row]
            searchBar.text = searchResults[indexPath.row]
            if indexPath.row < brandsEndIndex {
                performSegue(withIdentifier: "mainToSearchResultsSegue", sender: nil)
            } else {
                if(shouldPerformSegue(withIdentifier: "mainToVendorProfileSegue", sender: nil)){
                    performSegue(withIdentifier: "mainToVendorProfileSegue", sender: nil)
                }
            }
            
        } else {
            var filteredProducts:[ProductData] = allProductsInstance.allProducts.filter{($0.category.parent.contains(selectedCategoryName!)) || $0.category.name.contains(selectedCategoryName!)}
            if recommendationsFetched {
                filteredProducts = recommendations.filter{($0.category.parent.contains(selectedCategoryName!)) || $0.category.name.contains(selectedCategoryName!)}
            }
            let product = filteredProducts[indexPath.row]
            performSegue(withIdentifier: "mainToProductDetailSegue", sender: nil)
        }
        
    }
    
    /*
     function that determines if a tableviewcell data should be let to do swipe to delete action.
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == searchHistoryTableView {
            if indexPath.row < historyEndIndex {
                return true
            }
        }
        return false
    }

    /*
     function that performs the necessary data erasings after a tableviewcell is swiped to delete.
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            searchResults.remove(at: indexPath.row)
            searchHistory.remove(at: indexPath.row)
            UserDefaults.standard.set(searchHistory, forKey: K.searchHistoryKey)
            searchHistoryTableView.reloadData()
        }
    }
}

extension UIColor {
    /*
     extension function for creating a UIImage from a UIColor
     */
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

//MARK: - Extension UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /*
     function that returns the number of category cells.
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    /*
     function that fills out the name of the category to the CategoryCollectionViewCell.
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath)
            if let cell = cell as? CategoryCollectionViewCell {
                cell.delegate = self
                let categoryName = self.categories[indexPath.row]
                cell.setCategory(categoryName: categoryName)
                if self.categories[indexPath.row].caseInsensitiveCompare(selectedCategoryName ?? "") == .orderedSame {
                    cell.setAsCurrentCategory(isCurrentCategory: true)
                }else {
                    cell.setAsCurrentCategory(isCurrentCategory: false)
                }
            }
            return cell
        }
    
    /*
     function to determine the width and appearance of the CategoryCollectionViewCell to fit the category name properly.
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.categories[indexPath.row]
        let width = self.estimatedFrame(text: text, font: .systemFont(ofSize: 17.0)).width
        return CGSize(width: width+30.0, height: 35.0)
    }
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 200, height: 1000) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
    
}

//MARK: - Extension CellDelegate
extension MainViewController:CellDelegate {
    /*
     function that is called when a CategoryCollectionViewCell is selected.
     used for filtering the tableviewcells by the category chosen.
     */
    func didCellSelected(cell: UICollectionViewCell) {
        if let categoryCell = cell as? CategoryCollectionViewCell {
            self.selectedCategoryName=categoryCell.categoryName
            categoryCollectionView.reloadData()
            productTableView.reloadData()
        }
    }
}

extension MainViewController: AllProductsFetchDelegate {
    /*
     function that is called when all products of the database is fetched from the backend.
     also fetches the images of the products and saves them to the cache.
     also fetches the recommended products for the logged-in users if the amount of data of the user is sufficient.
     */
    func allProductsAreFetched() {
        self.stopIndicator()
        self.productTableView.reloadData()
        self.searchBar.isUserInteractionEnabled = true
        if let search_history = UserDefaults.standard.value(forKey: K.searchHistoryKey) as? [String]{
            var search_hist_str = ""
            if search_history.count == 1 {
                print("22")
                search_hist_str = search_history[0]
                APIManager().search(filterType: "none", sortType: "none", searchWord: search_hist_str) { (result) in
                    switch result {
                    case .success(let searchResults):
                        if searchResults.product_list!.count >= 10 {
                            self.recommendations = searchResults.product_list ?? []
                            self.recommendationsFetched = true
                            self.productTableView.reloadData()
                        } else {
                            self.recommendationsFetched = false
                        }
                    case .failure(let err):
                        print(err)
                        self.recommendationsFetched = false
                    }
                }
            } else if search_history.count > 1 {
                search_hist_str = search_history[search_history.count-1]
                APIManager().search(filterType: "none", sortType: "none", searchWord: search_hist_str) { (result) in
                    switch result {
                    case .success(let searchResults):
                        if searchResults.product_list!.count >= 10 {
                            self.recommendations = searchResults.product_list ?? []
                            self.recommendationsFetched = true
                            self.productTableView.reloadData()
                        } else {
                            self.recommendationsFetched = false
                        }
                    case .failure(let err):
                        print(err)
                        self.recommendationsFetched = false
                    }
                }
            }
            
        } else {
            self.recommendationsFetched = false
        }
    }
    
    /*
     function that is called when getAllProducts function's backend call throws an error.
     */
    func productsCannotBeFetched() {
        startIndicator()
        presentAlert()
        
    }
    
    /*
     function that shows an alert when getAllProducts function's backend call throws an error.
     */
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

extension MainViewController: AllVendorsFetchDelegate {
    /*
     function that is called when all vendors of the database is fetched from the backend.
     */
    func allVendorsAreFetched() {
        self.stopIndicator()
        self.vendors = self.allVendorsInstance.allVendors
        self.searchBar.isUserInteractionEnabled = true
    }
    
    /*
     function that is called when all vendors of the database cannot be fetched from the backend due to an error.
     */
    func vendorsCannotBeFetched() {
        startIndicator()
    }
}

// MARK: - SearchBar
extension MainViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    /*
     function that is automatically called when the text in search bar is changed.
     used for updating search results.
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = searchText.isEmpty ? searchHistory : searchHistory.filter{(query:String) -> (Bool) in
            return query.range(of:searchText, options: .caseInsensitive, range:nil, locale: nil) != nil
        }
        historyEndIndex = searchResults.count
        searchResults.append(contentsOf: categories.filter{(query:String) -> (Bool) in
                                return query.range(of:searchText, options: .caseInsensitive, range:nil, locale: nil) != nil})
        categoriesEndIndex = searchResults.count
        let brands = Array(Set(allProductsInstance.allProducts.map{$0.brand}))
        searchResults.append(contentsOf: brands.filter{(query:String) -> (Bool) in
                                return query.range(of:searchText, options: .caseInsensitive, range:nil, locale: nil) != nil})
        brandsEndIndex = searchResults.count
        let vendorlist = Array(Set(allVendorsInstance.allVendors.map{$0.company}))
        searchResults.append(contentsOf: vendorlist.filter{(query:String) -> (Bool) in
                                return query.range(of:searchText, options: .caseInsensitive, range:nil, locale: nil) != nil})
        searchHistoryTableView.reloadData()
    }
    
    /*
     function that is automatically called when the search bar text is started editing.
     used for showing the searchhistorytableview
     */
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResults = searchHistory
        self.searchBar.showsCancelButton = true
        self.searchHistoryTableView.isHidden = false
        self.view.bringSubviewToFront(searchHistoryTableView)
        self.view.bringSubviewToFront(searchHistoryTableView)
        self.searchHistoryTableView.setValue(1, forKeyPath: "alpha")
    }
    
    /*
     function that is automatically called when the search button is clicked.
     used for segueing to search results.
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchTextField?.text != "" {
            let brands = allProductsInstance.allProducts.map{$0.brand}
            if !searchHistory.contains(searchTextField!.text!) &&  !categories.contains(searchTextField!.text!) && !brands.contains(searchTextField!.text!){
                searchHistory.append(searchBar.text!)
            }
            UserDefaults.standard.set(searchHistory, forKey: K.searchHistoryKey)
        }
        searchHistoryTableView.setValue(0, forKeyPath: "alpha")
        if (shouldPerformSegue(withIdentifier: "mainToSearchResultsSegue", sender: nil)) {
            performSegue(withIdentifier: "mainToSearchResultsSegue", sender: nil)
        }
    }
    
    /*
     function that is automatically called when the cancel button is clicked.
     used for hiding searchhistorytableview and deleting the search text.
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        searchBar.text = ""
        searchHistoryTableView.isHidden = true
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        self.view.sendSubviewToBack(searchHistoryTableView)
        self.view.sendSubviewToBack(searchHistoryTableView)
    }
    
    
}



// MARK: - IndicatorView
extension MainViewController {
    /*
     function used for showing an activity indicator
     */
    func startIndicator() {
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        productTableView.isHidden = true
    }
    
    /*
     function that creates an activity indicator
     */
    func createIndicatorView() {
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        productTableView.isHidden = true
    }
    
    /*
     function used for stopping an activity indicator and arranging the view hierarchy
     */
    func stopIndicator() {
        DispatchQueue.main.async {
            self.logoImageView.isHidden = true
            self.loadingView.isHidden = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.view.sendSubviewToBack(self.loadingView)
            self.productTableView.isHidden = false
            self.productTableView.isUserInteractionEnabled = true
            self.productTableView.reloadData()
        }
    }
}

protocol AllProductsFetchDelegate {
    func allProductsAreFetched()
    func productsCannotBeFetched()
    func presentAlert()
}

class AllProducts {
    static let shared = AllProducts()
    var allProducts: [ProductData]
    var allImages: Dictionary<Int, UIImage>
    var allImageNames: [String]
    private let saveKey = "AllProducts"
    
    var delegate: AllProductsFetchDelegate?
    let dispatchGroup = DispatchGroup()
    var dataFetched = false {
        didSet{
            if self.dataFetched{
                delegate?.allProductsAreFetched()
            } else {
                delegate?.productsCannotBeFetched()
            }
        }
    }
    var apiFetchError = false
    var jsonParseError = false
    
    init(){
        self.allProducts = []
        self.allImages = Dictionary()
        self.allImageNames = []
    }
    
    /*
     function that fetches all products by using APIManager's getAllProducts function and also fetching their photos asynchronously and saving them to cache.
     */
    func fetchAllProducts() {
        dispatchGroup.enter()
        APIManager().getAllProducts(completionHandler: { products in
            if products != nil {
                self.dataFetched = true
                self.allProducts = products!
                let group = DispatchGroup()
                let serialQueue = DispatchQueue(label: "serialQueue")
                for prod in self.allProducts {
                    group.enter()
                    if let pic = prod.picture {
                        let url = URL(string: prod.picture!)
                        URLSession(configuration: .default).dataTask(with: url!) { (data, response, error) in
                            guard let data = data, let image = UIImage(data: data), error == nil else { group.leave(); return }
                            
                            // creates a synchronized access to the images array
                            serialQueue.async {
                                self.allImages[prod.id] = image
                                
                                // tells the group a pending process has been completed
                                group.leave()
                            }
                        }.resume()
                    } else {
                        group.leave()
                    }
                }
                group.wait()
                self.delegate?.allProductsAreFetched()
            } else {
                self.dataFetched = false
                self.allProducts = []
                self.delegate?.productsCannotBeFetched()
            }
        })
        dispatchGroup.leave()
        dispatchGroup.wait()
    }
}

class AllVendors {
    static let shared = AllVendors()
    var allVendors: [VendorData]
    private let saveKey = "AllVendors"
    
    var delegate: AllVendorsFetchDelegate?
    let dispatchGroup = DispatchGroup()
    var dataFetched = false {
        didSet{
            if self.dataFetched{
                delegate?.allVendorsAreFetched()
            } else {
                delegate?.vendorsCannotBeFetched()
            }
        }
    }
    var apiFetchError = false
    var jsonParseError = false
    
    init(){
        self.allVendors = []
    }
    
    /*
     function that fetches all vendors by using APIManager's getAllVendors function.
     */
    func fetchAllVendors() {
        dispatchGroup.enter()
        APIManager().getAllVendors(str:"", completionHandler: { result in
            switch result {
            case .success(let vendors):
                self.dataFetched = true
                self.allVendors = vendors
                self.delegate?.allVendorsAreFetched()
            case .failure(let err):
                print(err)
                self.dataFetched = false
                self.allVendors = []
                self.delegate?.vendorsCannotBeFetched()
                print(err)
            }
        })
        dispatchGroup.leave()
        dispatchGroup.wait()
    }
        
}

protocol AllVendorsFetchDelegate {
    func allVendorsAreFetched()
    func vendorsCannotBeFetched()
}

