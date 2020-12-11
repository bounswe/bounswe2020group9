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
    case Vendor , Customer
}

class SignUpViewController: UIViewController {
    
    @IBOutlet var signInButton: GIDSignInButton!
    @IBOutlet weak var isCustomerButton: RadioButton!
    @IBOutlet weak var isVendorButton: RadioButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var frameView: UIView!
    var signUpUserType: UserType?
    var delegate:SignUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameView.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        frameView.layer.shadowColor = UIColor.black.cgColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UserDefaults.standard.value(forKey: K.isLoggedinKey) as! Bool {
            self.dismiss(animated: true, completion: nil)
        }else {
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
                                            UserDefaults.standard.set(true, forKey: K.isLoggedinKey)
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func isVendorButtonPressed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if (self.signUpUserType != nil) {
                self.isCustomerButton.sendActions(for: .touchUpInside)
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
        } else{
            self.signUpUserType = nil
        }
    }
}
//MARK: - Extension GIDSignInDelegate
extension SignUpViewController: GIDSignInDelegate{
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
      // Perform any operations on signed in user here.
      let userId = user.userID                  // For client-side use only!
      let idToken = user.authentication.idToken // Safe to send to the server
      let fullName = user.profile.name
      let givenName = user.profile.givenName
      let familyName = user.profile.familyName
      let email = user.profile.email
        UserDefaults.standard.set(true, forKey: K.isLoggedinKey)
        self.dismiss(animated: true, completion: nil)
      // ...
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        UserDefaults.standard.set(false, forKey: K.isLoggedinKey)
      // Perform any operations when the user disconnects from app here.
      // ...
    }
    
}
