//
//  SearchViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 12.11.2020.
//

import UIKit

class CategoriesViewController:UIViewController  {
  
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchHistoryTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    
    var allProductsInstance = AllProducts_temp.shared
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
    
    override func viewWillAppear(_ animated: Bool) {
        searchHistoryTableView.reloadData()
        productTableView.reloadData()
        var searchTextField: UITextField?
        if #available(iOS 13.0, *) {
            searchTextField = searchBar.searchTextField
        } else {
            self.searchBar.barStyle = .default
            if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
                searchTextField = searchField
            }
        }
        searchTextField?.alpha = 1.0
            
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
        searchHistoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchHistoryCell")
        if !(allProductsInstance.dataFetched) {
            print("here")
            self.searchBar.resignFirstResponder()
            self.searchBar.isUserInteractionEnabled = false
            startIndicator()
            self.allProductsInstance.fetchAllProducts()
        }
        searchResults = searchHistory
        
    }
    
    
    func categorySelected () {
        self.productTableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchResultsVC = segue.destination as? SearchResultsViewController {
            searchResultsVC.searchWord = searchBar.searchTextField.text
            print("here10")
        }
        print("here11")
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "mainToSearchResultsSegue" {
            print("here12")
            return !(searchBar.searchTextField.text == "")
        } else {
            print("no segue")
            return false
        }
    }


}

extension CategoriesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
    

}

extension CategoriesViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        if tableView == productTableView {
            return allProductsInstance.allProducts.filter{$0.categories.contains(selectedCategoryName!)}.count
        }
        if tableView == searchHistoryTableView {
            return searchResults.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == productTableView {
            let cell = productTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell", for: indexPath) as! ProductCell
            //let filteredProducts:[Product] = products.filter { $0.category == selectedCategoryName }
            let filteredProducts:[ProductData] = allProductsInstance.allProducts.filter{$0.categories.contains(selectedCategoryName!)}
            let product = filteredProducts[indexPath.row]
            cell.productNameLabel.text = product.name
            cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
            cell.productDescriptionLabel.text = product.brand
            cell.productDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            cell.productPriceLabel.text = String(product.price)
            cell.productPriceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
            cell.productImageView.image = UIImage(named: "iphone12")
            return cell
        } else {
            let cell = searchHistoryTableView.dequeueReusableCell(withIdentifier: "searchHistoryCell", for: indexPath)
            cell.textLabel?.text = searchResults[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchHistoryTableView {
            searchBar.searchTextField.text = searchResults[indexPath.row]
            searchBar.text = searchResults[indexPath.row]
            performSegue(withIdentifier: "mainToSearchResultsSegue", sender: nil)
            print("f")
        }
        print("g")
    }
}


//MARK: - Extension UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
extension CategoriesViewController:CellDelegate {
    func didCellSelected(cell: UICollectionViewCell) {
        if let categoryCell = cell as? CategoryCollectionViewCell {
            self.selectedCategoryName=categoryCell.categoryName
            categoryCollectionView.reloadData()
            productTableView.reloadData()
        }
    }
}

extension CategoriesViewController: ProductsFetchDelegate {
    func allProductsAreFetched_temp() {
        stopIndicator()
        self.productTableView.reloadData()
        self.searchBar.isUserInteractionEnabled = true
        //DispatchQueue.main.async {
          //  self.productTableView.reloadData()
           // self.searchBar.isUserInteractionEnabled = true
        //}
    }
    
    func productsCannotBeFetched_temp() {
        startIndicator()
        presentAlert_temp()
        
    }
    
    func presentAlert_temp() {
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
extension CategoriesViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchHistoryTableView.isHidden = false
        searchResults = searchText.isEmpty ? searchHistory : searchHistory.filter{(query:String) -> (Bool) in
            return query.range(of:searchText, options: .caseInsensitive, range:nil, locale: nil) != nil
        }
        searchHistoryTableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        self.searchHistoryTableView.isHidden = false
        self.searchHistoryTableView.setValue(1, forKeyPath: "alpha")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.searchTextField.text != "" {
            if !searchHistory.contains(searchBar.searchTextField.text!) {
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
    }
    
    
}



// MARK: - IndicatorView
extension CategoriesViewController {
    func startIndicator() {
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
            self.productTableView.isHidden = false
            self.productTableView.reloadData()
        }
    }
}
protocol ProductsFetchDelegate {
    func allProductsAreFetched_temp()
    func productsCannotBeFetched_temp()
    func presentAlert_temp()
}





class AllProducts_temp {
    static let shared = AllProducts_temp()
    var allProducts: [ProductData]
    private let saveKey = "AllProducts"
    
    var delegate: ProductsFetchDelegate?
    let dispatchGroup = DispatchGroup()
    var dataFetched = false {
        didSet{
            if self.dataFetched{
                delegate?.allProductsAreFetched_temp()
            } else {
                delegate?.productsCannotBeFetched_temp()
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
                self.delegate?.allProductsAreFetched_temp()
            } else {
                self.dataFetched = false
                self.allProducts = []
                self.delegate?.productsCannotBeFetched_temp()
            }
        })
        dispatchGroup.leave()
        dispatchGroup.wait()
    }
        
}
