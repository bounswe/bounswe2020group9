//
//  SignUpViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 18.11.2020.
//

import UIKit
import GoogleSignIn

protocol SignUpViewControllerDelegate {
    func signUpViewControllerDidPressLoginHere()
}

enum UserType:Int {
    case Customer , Vendor
}

class SignUpViewController: UIViewController {

    @IBOutlet weak var isCustomerButton: RadioButton!
    @IBOutlet weak var isVendorButton: RadioButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var vendorInfoView: UIView!
    @IBOutlet weak var upDownConstraint: NSLayoutConstraint!
    
    var signUpUserType: UserType?
    var delegate:SignUpViewControllerDelegate?
    var isPressedLoginHere = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textContentType = .oneTimeCode
        frameView.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        frameView.layer.shadowColor = UIColor.black.cgColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.textContentType = .oneTimeCode
        isPressedLoginHere = false
        upDownConstraint.constant = 15
        if let isloggedin = UserDefaults.standard.value(forKey: K.isLoggedinKey){
            if isloggedin as! Bool{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vendorInfoView.isHidden = true
        self.upDownConstraint.constant = 15
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isPressedLoginHere{
            delegate?.signUpViewControllerDidPressLoginHere()
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

        if let firstName = firstNameTextField.text{
            if !firstName.isName {
                alertController.message = "Your First Name is invalid. Please enter a valid First Name."
                self.present(alertController, animated: true, completion: nil)
            }else {
                if let lastName = lastNameTextField.text {
                    if !lastName.isName {
                        alertController.message = "Your Last Name is invalid. Please enter a valid Last Name."
                        self.present(alertController, animated: true, completion: nil)
                    }else {
                        if let email = emailTextField.text {
                            if !email.isEmail {
                                alertController.message = "Your email address is invalid. Please enter a valid address."
                                self.present(alertController, animated: true, completion: nil)
                            }else{
                                if let password = passwordTextField.text{
                                    if password.count < 8 || password.count > 20 {
                                        alertController.message = "Password must be at least 8 , at most 20 characters in length"
                                        self.present(alertController, animated: true, completion: nil)
                                    }else {
                                        if let userType = self.signUpUserType{
                                            if userType.rawValue == 0 {
                                                APIManager().signUpCustomer(firstName:firstName,lastName: lastName,username: email, password: password, userType: "\(userType.rawValue+1)") { (result) in
                                                    switch result{
                                                    case .success(_):
                                                        let alertController2 = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
                                                        alertController2.message = "You have successfully signed up! To login, a mail has been sent to your e-mail address, please check and verify your e-mail"
                                                        alertController2.addAction(UIAlertAction(title: "Go To Login", style: UIAlertAction.Style.default){ (action:UIAlertAction!) in
                                                            self.dismiss(animated: true, completion: nil)
                                                        })
                                                        self.present(alertController2, animated: true, completion: nil)
                                                    case .failure(let err):
                                                        alertController.message = err.localizedDescription
                                                        self.present(alertController, animated: true, completion: nil)
                                                    }
                                                }
                                            }else {
                                                if let companyName = companyNameTextField.text {
                                                    if companyName.count < 2 {
                                                        alertController.message = "Company name must be at least 2 characters in length"
                                                        self.present(alertController, animated: true, completion: nil)
                                                    }else {
                                                        if let addressTitle = addressTextField.text {
                                                            if addressTitle.count < 1 {
                                                                alertController.message = "Address title must be at least 1 characters in length"
                                                                self.present(alertController, animated: true, completion: nil)
                                                            }else {
                                                                print("success")
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }else {
                                            alertController.message = "Choose one, Vendor or Customer"
                                            self.present(alertController, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func loginHereButtonPressed(_ sender: UIButton) {
        isPressedLoginHere=true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func isVendorButtonPressed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if (self.signUpUserType != nil) {
                self.isCustomerButton.sendActions(for: .touchUpInside)
            }
            DispatchQueue.main.async {
                self.vendorInfoView.isHidden = false
                self.upDownConstraint.constant = 120
            }
            self.signUpUserType = UserType.Vendor
        } else{
            self.signUpUserType = nil
        }
    }
    
    @IBAction func isCustomerButtonPressed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if (self.signUpUserType != nil) {
                self.isVendorButton.sendActions(for: .touchUpInside)
            }
            self.signUpUserType = UserType.Customer
            DispatchQueue.main.async {
                self.vendorInfoView.isHidden = true
                self.upDownConstraint.constant = 15
            }
        } else{
            self.signUpUserType = nil
        }
    }
}
