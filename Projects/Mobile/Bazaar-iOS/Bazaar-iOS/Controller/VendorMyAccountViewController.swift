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
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        if let firstName = firstNameTextField.text {
            if !firstName.isName {
                alertController.message = "Your First Name is invalid. Please enter a valid First Name."
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.firstName = firstName
        }
        if let lastName = lastNameTextField.text{
            if !lastName.isName {
                alertController.message = "Your Last Name is invalid. Please enter a valid Last Name."
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.lastName = lastName
        }
        
        if let authorization = UserDefaults.standard.value(forKey: K.token) as? String,let firstName = self.firstName,let lastName = self.lastName{
            APIManager().setProfileInfo(authorization: authorization, firstName: firstName, lastName: lastName) { (result) in
                switch result {
                case .success(_):
                    UserDefaults.standard.setValue(firstName, forKey: K.userFirstNameKey)
                    UserDefaults.standard.setValue(lastName, forKey: K.userLastNameKey)
                    alertController.message = "Your profile information has been successfully updated!"
                    self.present(alertController, animated: true, completion: nil)
                case .failure(_):
                    alertController.message = "Your profile information could not be updated!"
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }else {
            alertController.message = "Your profile information could not be updated!"
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        if let _ = UserDefaults.standard.value(forKey: K.isGoogleSignedInKey) as? Bool {
            alertController.message = "You cannot update your password because you are logged in with a Google account!"
            self.present(alertController, animated: true, completion: nil)
        }else {
            if let currentPassword = currentPasswordTextField.text {
                if currentPassword.count != 0 {
                    if let newPassword = newPasswordTextField.text {
                        if newPassword.count != 0 {
                            if newPassword.count < 8 || newPassword.count > 20 {
                                alertController.message = "New password must be at least 8 , at most 20 characters in length."
                                self.present(alertController, animated: true, completion: nil)
                                return
                            }else if let newPasswordAgain = newPasswordAgainTextField.text{
                                if newPasswordAgain.count != 0 {
                                    if newPassword != newPasswordAgain {
                                        alertController.message = "New passwords do not match!"
                                        self.present(alertController, animated: true, completion: nil)
                                        return
                                    }else {
                                        if let userId = UserDefaults.standard.value(forKey: K.userIdKey) as? Int{
                                            APIManager().updatePassword(userId:userId,currentPassword: currentPassword, newPassword: newPassword) { (result) in
                                                switch result{
                                                case .success(_):
                                                    alertController.message = "Your password has been successfully updated!"
                                                    self.present(alertController, animated: true, completion: nil)
                                                    self.currentPasswordTextField.text=""
                                                    self.newPasswordTextField.text = ""
                                                    self.newPasswordAgainTextField.text = ""
                                                case .failure(_):
                                                    alertController.message = "Wrong current password!"
                                                    self.present(alertController, animated: true, completion: nil)
                                                }
                                            }
                                        }else {
                                            alertController.message = "Password update failed!"
                                            self.present(alertController, animated: true, completion: nil)
                                        }
                                    }
                                }else {
                                    alertController.message = "Please, enter new password again!"
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }else{
                            alertController.message = "Please, enter new password!"
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }else {
                    alertController.message = "Please, enter current password!"
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
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
