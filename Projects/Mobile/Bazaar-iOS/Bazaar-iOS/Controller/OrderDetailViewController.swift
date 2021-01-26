//
//  OrderDetailViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 26.01.2021.
//

import UIKit

class OrderDetailViewController: UIViewController {

    @IBOutlet weak var productListTableView: UITableView!
    
    var orders:[OrderData]!
    var allProducts:[ProductData]!
    var amounts:[Int:Int]!
    
    let imageCache = NSCache<NSString,UIImage>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productListTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
        self.productListTableView.backgroundColor = UIColor.systemBackground
        
    }
    
    
    @IBAction func didBackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        for amount in amounts {
            self.allProducts = []
            APIManager().getProduct(p_id: amount.key) { (result) in
                switch result{
                case .success(let product):
                    self.allProducts.append(product)
                case .failure(_):
                    let alertController = UIAlertController(title: "Alert!", message: "There was an error loading your order, please try again later.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                     self.present(alertController, animated: true, completion: nil)
                }
            }
            self.productListTableView.reloadData()
        }
        
        //Producutları çek, foto, name, vendor?
        //orderTime
        //amountlar
        //location, card
        
    }
    
    
    
    
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(allProducts.count)
        return self.allProducts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productListTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell", for: indexPath) as! ProductCell
        let product = self.allProducts[indexPath.row]
        cell.productNameLabel.text = product.name
        cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        cell.productDescriptionLabel.isHidden = true
        cell.productPriceLabel.isHidden = true
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
        cell.amountLabel.text! += "\n\(String(describing: amounts[product.id]))"
        cell.amountLabel.isHidden = false
        return cell
    }
    
    
    
}

