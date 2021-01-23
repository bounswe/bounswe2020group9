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
    var vendor:VendorData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getVendorsProducts() {
        
    }
}
