//
//  CustomerOrdersViewController.swift
//  Bazaar-iOS
//
//  Created by Uysal, Sadi on 20.01.2021.
//

import UIKit
import GoogleSignIn

class CustomerOrdersViewController: UIViewController{
    

    @IBOutlet weak var ordersTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
