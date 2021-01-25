//
//  VendorNotificationViewController.swift
//  Bazaar-iOS
//
//  Created by Uysal, Sadi on 25.01.2021.
//

import UIKit
class VendorNotificationViewController: UIViewController{
    
    @IBOutlet weak var NotificationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

