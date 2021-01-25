//
//  VendorProfileForUserViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 19.01.2021.
//

import UIKit

class VendorProfileForUserViewController: UIViewController {

    var vendor:VendorData!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var vendorNameLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var delegate: VendorProfileForUserViewController?
    var products: [ProductData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.tableFooterView = UIView(frame: .zero)
        productsTableView.tableFooterView?.isHidden = true
        productsTableView.delegate = self
        productsTableView.dataSource = self
        setAttributes()
        productsTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
        productsTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func setAttributes() {
        APIManager().getLocationOfVendor(vendorId: vendor.id, completionHandler: { (result) in
            switch result {
            case .success(let addresses):
                DispatchQueue.main.async {
                    if addresses.count > 0 {
                        self.addressLabel.text = addresses[0].address
                    } else {
                        self.addressLabel.isHidden = true
                    }
                }
            case .failure(let err):
                print(err)
                DispatchQueue.main.async {
                    self.addressLabel.isHidden = true
                }
            }
                
            })
        vendorNameLabel.text = vendor.company
        vendorNameLabel.adjustsFontSizeToFitWidth = true
        products = AllProducts.shared.allProducts.filter{$0.vendor == vendor.id}
        let rating = calcAverageRating()
        if (rating == 0.0) {
            ratingButton.setTitle("No reviews yet.", for: .normal)
        } else {
            ratingButton.setTitle(String(rating), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func messageButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "vendorProfileToSendMessageSegue", sender: nil)
    }
    
    func calcAverageRating() -> Double {
        return (Double((products.map{$0.rating}).reduce(0, +))/Double(products.count)).rounded(toPlaces: 2)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let productDetailVC = segue.destination as? ProductDetailViewController {
            let indexPath = self.productsTableView.indexPathForSelectedRow
            if indexPath != nil {
                productDetailVC.product = products[indexPath!.row]
            }
        } else if let sendMsgVC = segue.destination as? SendMessageViewController {
            sendMsgVC.company = self.vendor.email
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "vendorProfileForUserToProductDetailSegue" {
             return self.productsTableView.indexPathForSelectedRow != nil
        }
        return false
    }
    
}

extension VendorProfileForUserViewController: UITableViewDelegate, UITableViewDataSource {
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
            cell.productImageView.image = AllProducts.shared.allImages[product.id]
            cell.productImageView.contentMode = .scaleAspectFit
        } else {
            if let url = product.picture {
                do{
                    try _ = cell.productImageView.loadImageUsingCache(withUrl: url, forProduct: product)
                    cell.productImageView.contentMode = .scaleAspectFit
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        if (shouldPerformSegue(withIdentifier: "vendorProfileForUserToProductDetailSegue", sender: nil)) {
            performSegue(withIdentifier: "vendorProfileForUserToProductDetailSegue", sender: nil)
        }
    }
    
    
}
