//
//  ViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 8.11.2020.
//

import UIKit

class MainViewController: UIViewController{

    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchHistoryTableView: UITableView!
    
    
    var allProductsInstance = AllProducts.shared
    var selectedCategoryName: String?

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
    let categoriesReuseIdentifier = "CategoriesCollectionViewCell"
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving products", message: "We encountered a problem while retrieving the products, please check your internet connection.", preferredStyle: .alert)
    var searchHistory:[String] = (UserDefaults.standard.value(forKey: K.searchHistoryKey) as? [String] ?? [])
    var searchResults:[String] = []
    var historyEndIndex:Int = 0
    var categoriesEndIndex: Int = 0
    var searchTextField: UITextField?
    
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
        searchTextField?.alpha = 1.0
        searchResults = searchHistory
        historyEndIndex = searchHistory.count
        categoriesEndIndex = searchHistory.count
        productTableView.tableFooterView = UIView(frame: .zero)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
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
        searchHistoryTableView.isHidden = true
        self.view.sendSubviewToBack(searchHistoryTableView)
        self.view.sendSubviewToBack(searchHistoryTableView)
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier:  "CategoryCollectionViewCell")
        //generateProducts()
        createIndicatorView()
        let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
            // fetch products
            self.allProductsInstance.fetchAllProducts()
        })
        networkFailedAlert.addAction(okButton)
        selectedCategoryName = CLOTHING
        productTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
        //searchHistoryTableView.register(SearchHistoryTableViewCell.self, forCellReuseIdentifier: "searchHistoryCell")
        if !(allProductsInstance.dataFetched) {
            print("here")
            self.searchBar.resignFirstResponder()
            self.searchBar.isUserInteractionEnabled = false
            startIndicator()
            self.allProductsInstance.fetchAllProducts()
        }
        searchResults = searchHistory
        historyEndIndex = searchHistory.count
        
    }
    
    
    func categorySelected () {
        self.productTableView.reloadData()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.searchBar.showsCancelButton = false
        
        searchHistoryTableView.isHidden = true
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        self.view.sendSubviewToBack(searchHistoryTableView)
        self.view.sendSubviewToBack(searchHistoryTableView)
        searchResults = searchHistory
        if let searchResultsVC = segue.destination as? SearchResultsViewController {
            searchResultsVC.searchWord = searchTextField?.text
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
                } else {
                    searchResultsVC.isSearchWord = false
                    searchResultsVC.isBrand = true
                    searchResultsVC.isCategory = false
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
                let products = allProductsInstance.allProducts.filter{$0.category.parent!.contains(selectedCategoryName!) || $0.category.name.contains(selectedCategoryName!)}
                productDetailVC.product = products[indexPath!.row]
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "mainToSearchResultsSegue" {
            return !(searchTextField?.text == "")
        } else if identifier == "mainToProductDetailSegue" {
             return self.productTableView.indexPathForSelectedRow != nil
        }
        return false
    }


}

//extension MainViewController: UIScrollViewDelegate {
//  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y != 0 {
//            scrollView.contentOffset.y = 0
//            scrollView.
//        }
//    }
    

//}

extension MainViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        if tableView == productTableView {
            return allProductsInstance.allProducts.filter{($0.category.parent?.contains(selectedCategoryName!))! || $0.category.name.contains(selectedCategoryName!)}.count
        }
        if tableView == searchHistoryTableView {
            return searchResults.count
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == productTableView {
            let cell = productTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell", for: indexPath) as! ProductCell
            //let filteredProducts:[Product] = products.filter { $0.category == selectedCategoryName }
            let filteredProducts:[ProductData] = allProductsInstance.allProducts.filter{($0.category.parent?.contains(selectedCategoryName!))! || $0.category.name.contains(selectedCategoryName!)}
            let product = filteredProducts[indexPath.row]
            cell.productNameLabel.text = product.name
            cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
            cell.productDescriptionLabel.text = product.brand
            cell.productDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            cell.productPriceLabel.text = "₺"+String(product.price) 
            cell.productPriceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            if let url = product.picture {
                do{
                    try cell.productImageView.loadImageUsingCache(withUrl: url)
                } catch let error {
                    print(error)
                    cell.productImageView.image = UIImage(named:"xmark.circle")
                    cell.productImageView.tintColor = UIColor.lightGray
                }
            } else {
                cell.productImageView.image = UIImage(named:"xmark.circle")
                cell.productImageView.tintColor = UIColor.lightGray
                cell.productImageView.contentMode = .center
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
            } else {
                cell.hideClock()
                cell.showType()
                cell.typeLabel.text = "Brand"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchHistoryTableView {
            searchTextField?.text = searchResults[indexPath.row]
            searchBar.text = searchResults[indexPath.row]
            performSegue(withIdentifier: "mainToSearchResultsSegue", sender: nil)
        } else {
            let filteredProducts:[ProductData] = allProductsInstance.allProducts.filter{($0.category.parent?.contains(selectedCategoryName!))! || $0.category.name.contains(selectedCategoryName!)}
            let product = filteredProducts[indexPath.row]
            print(product.name)
            performSegue(withIdentifier: "mainToProductDetailSegue", sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == searchHistoryTableView {
            if indexPath.row < historyEndIndex {
                return true
            }
        }
        return false
    }

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
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

//MARK: - Extension UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
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
    func didCellSelected(cell: UICollectionViewCell) {
        if let categoryCell = cell as? CategoryCollectionViewCell {
            self.selectedCategoryName=categoryCell.categoryName
            categoryCollectionView.reloadData()
            productTableView.reloadData()
        }
    }
}

extension MainViewController: AllProductsFetchDelegate {
    func allProductsAreFetched() {
        stopIndicator()
        self.productTableView.reloadData()
        self.searchBar.isUserInteractionEnabled = true
        //DispatchQueue.main.async {
          //  self.productTableView.reloadData()
           // self.searchBar.isUserInteractionEnabled = true
        //}
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

// MARK: - SearchBar
extension MainViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
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
        searchHistoryTableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResults = searchHistory
        self.searchBar.showsCancelButton = true
        self.searchHistoryTableView.isHidden = false
        self.view.bringSubviewToFront(searchHistoryTableView)
        self.view.bringSubviewToFront(searchHistoryTableView)
        self.searchHistoryTableView.setValue(1, forKeyPath: "alpha")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchTextField?.text != "" {
            let brands = allProductsInstance.allProducts.map{$0.brand}
            if !searchHistory.contains(searchTextField!.text!) &&  !categories.contains(searchTextField!.text!) && !brands.contains(searchTextField!.text!){
                searchHistory.append(searchBar.text!)
            }
            UserDefaults.standard.set(searchHistory, forKey: K.searchHistoryKey)
            //searchHistoryTableView.reloadData()
        }
        searchHistoryTableView.setValue(0, forKeyPath: "alpha")
        if (shouldPerformSegue(withIdentifier: "mainToSearchResultsSegue", sender: nil)) {
            performSegue(withIdentifier: "mainToSearchResultsSegue", sender: nil)
        }
    }
    
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
    func startIndicator() {
        self.view.bringSubviewToFront(loadingView)
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        productTableView.isHidden = true
    }

    func createIndicatorView() {
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        productTableView.isHidden = true
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
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
    }
    
    func fetchAllProducts() {
        dispatchGroup.enter()
        APIManager().getAllProducts(completionHandler: { products in
            if products != nil {
                self.dataFetched = true
                self.allProducts = products!
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


/*
 func generateProducts() {
     
     products.append(Product(title: "Made in France Crewneck Organic Cotton Sweathsirt", brand: "Lacoste", category: CLOTHING, price: "$175.00", photo: "2"))
     products.append(Product(title: "12.12 Chronograph Watch with Black Silicone Strap", brand: "Lacoste", category: CLOTHING, price: "$160.00", photo: "1"))
     products.append(Product(title: "Court Slam Tonal Leather Trainers", brand: "Lacoste", category: CLOTHING, price: "$115.00", photo: "3"))
     products.append(Product(title: "Brushed Checkered Scarf", brand: "Urban Outfitters", category: CLOTHING, price: "$34.00", photo: "4"))
     products.append(Product(title: "Hand Painted Denim Trucker Jacket", brand: "Veni Vidi Vici", category: CLOTHING, price: "$299.00", photo: "5"))
     products.append(Product(title: "Back 2 Back Crewneck Sweatshirt", brand: "Chinatown Market", category: CLOTHING, price: "$89.00", photo: "6"))
     products.append(Product(title: "Vintage Spliced Graphic Tee", brand: "Urban Renewal", category: CLOTHING, price: "$49.00", photo: "7"))
     products.append(Product(title: "Long Sleeve Football Tee", brand: "Champion", category: CLOTHING, price: "$49.00", photo: "8"))
     products.append(Product(title: "2976 Bex Chelsea Boots", brand: "Dr. Martens", category: CLOTHING, price: "$160.00", photo: "9"))
     products.append(Product(title: "Player Bucket Hat", brand: "Polo Ralph Lauren", category: CLOTHING, price: "$59.50", photo: "10"))
     products.append(Product(title: "Celestial Tie-Dye Placement", brand: "Urban Outfitters", category: HOME, price: "$12.00", photo: "11"))
     products.append(Product(title: "Standing Mixer", brand: "SMEG", category: HOME, price: "$529.50", photo: "12"))
     products.append(Product(title: "Matin Table Lamp", brand: "HAY", category: HOME, price: "$146.00", photo: "13"))
     products.append(Product(title: "Runa Pouf", brand: "Urban Outfitters", category: HOME, price: "$99.00", photo: "14"))
     products.append(Product(title: "Small White Ceramic Vase Set", brand: "Sullivans", category: HOME, price: "$24.99", photo: "15"))
     products.append(Product(title: "Modern Ashlar Accent Chair", brand: "Studio Designs", category: HOME, price: "$259.99", photo: "16"))
     products.append(Product(title: "3-Shelf Bookcase", brand: "Mainstay", category: HOME, price: "$99.50", photo: "17"))
     products.append(Product(title: "Office Desktop Bookshelf", brand: "Ticktecklab", category: HOME, price: "$26.59", photo: "18"))
     products.append(Product(title: "Tamarack Folding Wooden Outdoor Chair", brand: "CleverMade", category: HOME, price: "$159.99", photo: "19"))
     products.append(Product(title: "Reading Frog Family", brand: "SPI", category: HOME, price: "$187.00", photo: "20"))
     products.append(Product(title: "Win-Win Good Genes Duo Gift Set", brand: "Sunday Riley", category: BEAUTY, price: "$122.00", photo: "21"))
     products.append(Product(title: "Le Mini Macaron Gel Manicure Set", brand: "Urban Outfitters", category: BEAUTY, price: "$30.00", photo: "22"))
     products.append(Product(title: "Highlighting Duo Pencil", brand: "Anastasia Beverly Hills", category: BEAUTY, price: "$23.00", photo: "23"))
     products.append(Product(title: "Stimulating Scalp Scrub", brand: "Frank Body", category: BEAUTY, price: "$19.00", photo: "24"))
     products.append(Product(title: "Hoola Matte Bronzer", brand: "Benefit Cosmetics", category: BEAUTY, price: "$44.00", photo: "25"))
     products.append(Product(title: "Drying Lotion", brand: "Mario Badescu", category: BEAUTY, price: "$17.00", photo: "26"))
     products.append(Product(title: "Matte Softwear Brush", brand: "Lime Crime", category: BEAUTY, price: "$22.00", photo: "27"))
     products.append(Product(title: "Facial Spray With Aloe, Cucumber and Green Tea", brand: "Mario Badescu", category: BEAUTY, price: "$7.00", photo: "28"))
     products.append(Product(title: "Dew It For The Glow Gift Set", brand: "Mario Badescu", category: BEAUTY, price: "$28.00", photo: "29"))
     products.append(Product(title: "Roller Lash Curling Mascara", brand: "Benefit", category: BEAUTY, price: "$25.00", photo: "30"))
     products.append(Product(title: "Allure Voice-Activated Home Speaker with Alexa", brand: "Harman Kardon", category: ELECTRONICS, price: "$119.00", photo: "32"))
     products.append(Product(title: "Stanmore II Wireless Smart Speaker", brand: "Marshall", category: ELECTRONICS, price: "$395.99", photo: "31"))
     products.append(Product(title: "Nintendo Switch Lite", brand: "Nintendo", category: ELECTRONICS, price: "249.00", photo: "33"))
     products.append(Product(title: "Wireless Charger", brand: "Anker", category: ELECTRONICS, price: "$12.99", photo: "34"))
     products.append(Product(title: "USB-C Charge Cable (2m)", brand: "Apple", category: ELECTRONICS, price: "$19.00", photo: "39"))
     products.append(Product(title: "Laptop Stand", brand: "Soundance", category: ELECTRONICS, price: "$29.90", photo: "35"))
     products.append(Product(title: "DualShock 4 Wireless Controller for PS4", brand: "Playstation", category: ELECTRONICS, price: "$64.99", photo: "36"))
     products.append(Product(title: "USB-C to HDMI Adapter", brand: "QGeeM", category: ELECTRONICS, price: "$10.99", photo: "37"))
     products.append(Product(title: "Wireless Bluetooth Karaoke Microphone", brand: "Bonaok", category: ELECTRONICS, price: "$30.99", photo: "38"))
     products.append(Product(title: "iPhone 12 64 GB", brand: "Apple", category: ELECTRONICS, price: "$829.00", photo: "iphone12"))
     
     

     

 }
 */
