//
//  LoginViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 18.11.2020.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var frameView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        frameView.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
    }
    
}
