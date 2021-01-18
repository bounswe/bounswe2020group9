//
//  VendorMyAccountViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 18.01.2021.
//

import UIKit

class VendorMyAccountViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordAgainTextField: UITextField!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var myAddressView: UIView!
    var firstName:String?
    var lastName:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newPasswordTextField.textContentType = .oneTimeCode
        currentPasswordTextField.textContentType = .oneTimeCode
        newPasswordAgainTextField.textContentType = .oneTimeCode
        infoView.layer.borderColor = #colorLiteral(red: 0.2549019608, green: 0.6823529412, blue: 0.662745098, alpha: 1)
        passwordView.layer.borderColor = #colorLiteral(red: 0.2549019608, green: 0.6823529412, blue: 0.662745098, alpha: 1)
        myAddressView.layer.borderColor = #colorLiteral(red: 0.2549019608, green: 0.6823529412, blue: 0.662745098, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let firstName = UserDefaults.standard.value(forKey: K.userFirstNameKey) as? String{
            firstNameTextField.text = firstName
        }else {
            firstNameTextField.text = ""
        }
        if let lastName = UserDefaults.standard.value(forKey: K.userLastNameKey) as? String{
            lastNameTextField.text = lastName
        }else {
            lastNameTextField.text = ""
        }
        if let email = UserDefaults.standard.value(forKey: K.usernameKey) as? String{
            emailLabel.text = email
        }else {
            emailLabel.text = ""
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
    }
    @IBAction func updateButtonPressed(_ sender: UIButton) {
    }
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.setValue(nil, forKey: K.searchHistoryKey)
        UserDefaults.standard.setValue(nil, forKey: K.userTypeKey)
        UserDefaults.standard.setValue(nil, forKey: K.token)
        UserDefaults.standard.setValue(nil, forKey: K.userIdKey)
        UserDefaults.standard.setValue(nil, forKey: K.isGoogleSignedInKey)
        UserDefaults.standard.setValue(nil, forKey: K.userFirstNameKey)
        UserDefaults.standard.setValue(nil, forKey: K.userLastNameKey)
        UserDefaults.standard.setValue(nil, forKey: K.usernameKey)
        UserDefaults.standard.setValue(nil, forKey: K.userAddressKey)
        UserDefaults.standard.setValue(nil, forKey: K.userPhoneNumKey)
        UserDefaults.standard.setValue(false, forKey: K.isLoggedinKey)
        UserDefaults.standard.setValue(nil, forKey: K.isVendorLoggedIn)
        self.dismiss(animated: true, completion: nil)
    }
}
