//
//  VendorProfileViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 12.01.2021.
//

import UIKit

class VendorProfileViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        menuView.layer.borderColor = #colorLiteral(red: 0.2549019608, green: 0.6823529412, blue: 0.662745098, alpha: 1)
        menuView.layer.shadowColor = UIColor.black.cgColor
        super.viewDidLoad()
    }
}
