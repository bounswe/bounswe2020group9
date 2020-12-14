//
//  MyAccountViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 13.12.2020.
//

import UIKit
import GoogleSignIn

class MyAccountViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstName = UserDefaults.standard.value(forKey: K.userFirstNameKey) as? String{
            firstNameTextField.text = firstName
        }
        if let lastName = UserDefaults.standard.value(forKey: K.userLastNameKey) as? String{
            lastNameTextField.text = lastName
        }
        if let email = UserDefaults.standard.value(forKey: K.usernameKey) as? String{
            emailLabel.text = email
        }
        if let userName = UserDefaults.standard.value(forKey: K.usernameKey) as? String{
            userNameLabel.text = userName
        }
        if let address = UserDefaults.standard.value(forKey: K.userAddressKey) as? String{
            addressTextView.text = address
        }
        if let phoneNumber = UserDefaults.standard.value(forKey: K.userPhoneNumKey) as? String{
            phoneNumberTextField.text = phoneNumber
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set(nil, forKey: K.userFirstNameKey)
        UserDefaults.standard.set(nil, forKey: K.userLastNameKey)
        UserDefaults.standard.set(nil, forKey: K.usernameKey)
        UserDefaults.standard.set(nil, forKey: K.userAddressKey)
        UserDefaults.standard.set(nil, forKey: K.userPhoneNumKey)
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
