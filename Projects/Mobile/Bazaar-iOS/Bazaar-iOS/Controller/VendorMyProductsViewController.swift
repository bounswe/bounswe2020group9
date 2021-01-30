//
//  VendorMyProductsViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 12.01.2021.
//

import UIKit

class VendorMyProductsViewController: UIViewController {
    
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var productsTableView: UITableView!
    var vendor:VendorData?
    var products:[ProductData] = []
    
    /*
     function that is automatically called when the view first appears on screen.
     used for fetching API related data and setting the initial values for the views.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
        
        if let vendorId = UserDefaults.standard.value(forKey: K.userIdKey) as? Int{
            APIManager().getVendorsProducts(vendorId: vendorId) { (result) in
                switch result {
                case .success(let products):
                    self.products = products
                    self.productsTableView.reloadData()
                    DispatchQueue.main.async {
                        self.productsTableView.reloadData()
                    }
                case .failure(let error):
                    self.products = []
                    print(error)
                }
            }
        }
    }
    /*
     function that is automatically called every time before the view will appear on screen.
     used for reloading the data for the table view.
     */
    override func viewWillAppear(_ animated: Bool) {
        self.productsTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let addEditProductVC = segue.destination as? VendorAddEditProductViewController {
            let indexPath = self.productsTableView.indexPathForSelectedRow
            addEditProductVC.delegate = self
            if indexPath != nil {
                addEditProductVC.product = products[indexPath!.row]
                addEditProductVC.isEdit = true
            } else {
                addEditProductVC.isEdit = false
            }
        }
    }
    
    /*
     function that is called when the + button on the top right is pressed.
     used for segueing to VendorAddEditProductViewController.
     */
    @IBAction func addProductButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "VendorMyProductsToAddEditProductSegue", sender: nil)
    }
    
    
     /*function that decides if a segue from this view controller to another should be performed or not.
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "VendorMyProductsToAddEditProductSegue" {
             return self.productsTableView.indexPathForSelectedRow != nil
        }
        return false
    }
}

extension VendorMyProductsViewController: UITableViewDelegate, UITableViewDataSource {
    /*
     function that sets the number of rows in a tableview.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    /*
     function that is called for filling out the data of a UITableViewCell while it's rendered
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell") as! ProductCell
        let product = products[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        cell.productDescriptionLabel.text = product.brand
        cell.productDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.productPriceLabel.text = "₺"+String(product.price)
        cell.productPriceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        print("ehh",product)
        if AllProducts.shared.allImages.keys.contains(product.id) {
            cell.productImageView.image = AllProducts.shared.allImages[product.id]
            cell.productImageView.contentMode = .scaleAspectFit
        } else {
            if let url = product.picture {
                do{
                    if product.picture != "<null>" {
                        try _ = cell.productImageView.loadImageUsingCache(withUrl: url, forProduct: product)
                        cell.productImageView.contentMode = .scaleAspectFit
                    } else {
                        cell.productImageView.image = UIImage(named:"xmark.circle")
                        cell.productImageView.tintColor = UIColor.lightGray
                        cell.productImageView.contentMode = .center
                    }
                    
                } catch let error {
                    print(error)
                    cell.productImageView.image = UIImage(named:"xmark.circle")
                    cell.productImageView.tintColor = UIColor.lightGray
                    cell.productImageView.contentMode = .center
                }
            } else {
                cell.productImageView.image = UIImage(named:"xmark.circle")
                cell.productImageView.tintColor = UIColor.lightGray
                cell.productImageView.contentMode = .center
            }
        }
        cell.arrowImageView.image = UIImage(systemName: "pencil")
        cell.arrowImageView.tintColor = #colorLiteral(red: 0.2549019608, green: 0.6823529412, blue: 0.662745098, alpha: 1)
        return cell
    }
    
    /*
     function that is called when a UITableViewCell is selected via clicking.
     used for segueing to VendorAddEditProductViewController.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (shouldPerformSegue(withIdentifier: "VendorMyProductsToAddEditProductSegue", sender: nil)) {
            performSegue(withIdentifier: "VendorMyProductsToAddEditProductSegue", sender: nil)
        }
    }
    
}

extension VendorMyProductsViewController: VendorAddEditProductViewControllerDelegate {
    /*
     function that is called when a new product is added or some product is edited.
     fetches the final version of vendor's products by using APIManager's getVendorsProducts function.
     */
    func vendorAddEditProductViewControllerResponse() {
        if let vendorId = UserDefaults.standard.value(forKey: K.userIdKey) as? Int{
            APIManager().getVendorsProducts(vendorId: vendorId) { (result) in
                switch result {
                case .success(let products):
                    self.products = products
                    self.productsTableView.reloadData()
                    DispatchQueue.main.async {
                        self.productsTableView.reloadData()
                    }
                case .failure(let error):
                    self.products = []
                    print(error)
                // error ver
                }
            }
        }
    }
}
