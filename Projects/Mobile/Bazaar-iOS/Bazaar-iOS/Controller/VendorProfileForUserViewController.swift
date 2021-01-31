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
    
    /*
     function that is automatically called when the view first appears on screen.
     used for setting the initial values for the views.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.tableFooterView = UIView(frame: .zero)
        productsTableView.tableFooterView?.isHidden = true
        productsTableView.delegate = self
        productsTableView.dataSource = self
        setAttributes()
        productsTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
        productsTableView.reloadData()
    }
    
    /*
     function that is used for fetching the location information of the vendor and setting other values for the vendor information.
     */
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
    
    /*
     function that is automatically called every time before the view will appear on screen.
     used for setting the top navigation bar hidden.
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /*
     function that is automatically called every time before the view will disappear from the screen.
     used for setting the top navigation bar visible.
     */
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /*
     function that is used for segueing to the previous view controller when the back button is pressed.
     */
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    /*
     function that is used for segueing to the messaging view controller when the message button is pressed.
     */
    @IBAction func messageButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "vendorProfileToSendMessageSegue", sender: nil)
    }
    
    /*
     function that is used for calculating the average rating score of the vendor.
     */
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
    
    /*
     function that decides if a segue from this view controller to another should be performed or not.
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "vendorProfileForUserToProductDetailSegue" {
             return self.productsTableView.indexPathForSelectedRow != nil
        }
        return false
    }
    
}

extension VendorProfileForUserViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    /*
     function that is called when a UITableViewCell is selected via clicking.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        if (shouldPerformSegue(withIdentifier: "vendorProfileForUserToProductDetailSegue", sender: nil)) {
            performSegue(withIdentifier: "vendorProfileForUserToProductDetailSegue", sender: nil)
        }
    }
    
    
}
