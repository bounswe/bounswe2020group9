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
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        if let username = UserDefaults.standard.value(forKey: K.usernameKey) as? String{
            APIManager().resetPasswordEmail(username: username) { (result) in
                switch result{
                case .success(_):
                    alertController.message = "A mail has been sent to your email, please check it!"
                    self.present(alertController, animated: true, completion: nil)
                case .failure(_):
                    alertController.message = "There was a problem resetting your password!"
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
