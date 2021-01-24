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
                // error ver
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.productsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addEditProductVC = segue.destination as? VendorAddEditProductViewController {
            let indexPath = self.productsTableView.indexPathForSelectedRow
            if indexPath != nil {
                addEditProductVC.product = products[indexPath!.row]
                addEditProductVC.isEdit = true
            } else {
                addEditProductVC.product = products[0]
                addEditProductVC.isEdit = false
            }
        }
    }
    
    @IBAction func addProductButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "VendorMyProductsToAddEditProductSegue", sender: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "VendorMyProductsToAddEditProductSegue" {
             return self.productsTableView.indexPathForSelectedRow != nil
        }
        return false
    }
}

extension VendorMyProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell") as! ProductCell
        let product = products[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        cell.productDescriptionLabel.text = product.brand
        cell.productDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.productPriceLabel.text = "₺"+String(product.price)
        cell.productPriceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        if AllProducts.shared.allImages.keys.contains(product.id) {
            print(product.name, product.picture, "1")
            cell.productImageView.image = AllProducts.shared.allImages[product.id]
            cell.productImageView.contentMode = .scaleAspectFit
        } else {
            if let url = product.picture {
                print(product.name, product.picture)
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
            }
        }
        cell.arrowImageView.image = UIImage(systemName: "pencil")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (shouldPerformSegue(withIdentifier: "VendorMyProductsToAddEditProductSegue", sender: nil)) {
            performSegue(withIdentifier: "VendorMyProductsToAddEditProductSegue", sender: nil)
        }
    }
    
}
