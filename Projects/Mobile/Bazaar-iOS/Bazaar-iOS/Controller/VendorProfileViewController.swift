//
//  VendorProfileViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 12.01.2021.
//

import UIKit

class VendorProfileViewController: UIViewController {
    
    @IBOutlet weak var vendorNameLabel: UILabel!
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        menuView.layer.borderColor = #colorLiteral(red: 0.2549019608, green: 0.6823529412, blue: 0.662745098, alpha: 1)
        menuView.layer.shadowColor = UIColor.black.cgColor
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let isVendorLoggedIn =  UserDefaults.standard.value(forKey: K.isVendorLoggedIn) as? Bool {
            if !isVendorLoggedIn {
                self.dismiss(animated: true, completion: nil)
            }else {
                if let firstName = UserDefaults.standard.value(forKey: K.userFirstNameKey) as? String , let lastName = UserDefaults.standard.value(forKey: K.userLastNameKey) as? String  {
                    if firstName.count == 0 && lastName.count == 0 {
                        if let username = UserDefaults.standard.value(forKey: K.usernameKey) as? String  {
                            self.vendorNameLabel.text = username
                        }
                    }else {
                        self.vendorNameLabel.text = "\(firstName) \(lastName)"
                    }
                }else if let username = UserDefaults.standard.value(forKey: K.usernameKey) as? String  {
                    self.vendorNameLabel.text = username
                    
                }
            }
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
