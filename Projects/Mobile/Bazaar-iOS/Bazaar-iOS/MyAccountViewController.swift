//
//  MyAccountViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 13.12.2020.
//

import UIKit
import GoogleSignIn

class MyAccountViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: K.isLoggedinKey)
        GIDSignIn.sharedInstance().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
    }
}
