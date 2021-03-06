//
//  LoginViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 18.11.2020.
//

import UIKit
import GoogleSignIn

protocol LoginViewControllerDelegate {
    func loginViewControllerDidPressSignUp()
    func loginViewControllerDidPressContinueAsGuest()
    func loginViewControllerDidloggedIn()
}

class LoginViewController: UIViewController {
    
    @IBOutlet var signInButton: GIDSignInButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var frameView: UIView!
    var delegate:LoginViewControllerDelegate?
    var isSignUpPressed = false
    var isContinueAsGuestPressed = false
    var isLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.textContentType = .oneTimeCode
        frameView.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        frameView.layer.shadowColor = UIColor.black.cgColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isContinueAsGuestPressed = false
        isSignUpPressed = false
        isLoggedIn = false
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        //GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        if let isloggedin = UserDefaults.standard.value(forKey: K.isLoggedinKey){
            if isloggedin as! Bool{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isSignUpPressed {
            delegate?.loginViewControllerDidPressSignUp()
        }
        if isContinueAsGuestPressed{
            delegate?.loginViewControllerDidPressContinueAsGuest()
        }
        if isLoggedIn {
            delegate?.loginViewControllerDidloggedIn()
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        isSignUpPressed=true
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func continueAsGuestButtonPressed(_ sender: UIButton) {
        isContinueAsGuestPressed=true
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func forgotButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        if let username = emailTextField.text {
            if !username.isEmail {
                alertController.message = "Please enter correct e-mail and press the Forgot Password button again!"
                self.present(alertController, animated: true, completion: nil)
                
            }else {
                APIManager().resetPasswordEmail(username: username) { (result) in
                    switch result{
                    case .success(_):
                        alertController.message = "A mail has been sent to your e-mail, please check! If the mail has not reached you, check the e-mail you entered and try again."
                        self.present(alertController, animated: true, completion: nil)
                    case .failure(_):
                        alertController.message = "There was a problem resetting your password!"
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }else {
            alertController.message = "Please enter your e-mail and press the Forgot Password button again!"
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
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
                        APIManager().authenticate(username: email, password: password) { (result) in
                            switch result {
                            case .success(let token):
                                APIManager().getProfileInfo(authorization: token) { (result) in
                                    switch result {
                                    case .success(let profileInfo):
                                        UserDefaults.standard.set(profileInfo.first_name, forKey: K.userFirstNameKey)
                                        UserDefaults.standard.set(profileInfo.last_name, forKey: K.userLastNameKey)
                                        UserDefaults.standard.set(profileInfo.id, forKey: K.userIdKey)
                                        UserDefaults.standard.set(profileInfo.user_type, forKey: K.userTypeKey)
                                        UserDefaults.standard.set(email, forKey: K.usernameKey)
                                        if profileInfo.user_type == 2 {
                                            UserDefaults.standard.set(true, forKey: K.isVendorLoggedIn)
                                            self.emailTextField.text = ""
                                            self.passwordTextField.text = ""
                                            self.performSegue(withIdentifier: "goToVendorSide", sender: nil)
                                        }else{
                                            UserDefaults.standard.set(true, forKey: K.isLoggedinKey)
                                            self.isLoggedIn = true
                                            self.dismiss(animated: false, completion: nil)
                                        }
                                    case .failure(_): break
                                    }
                                }
                            case .failure(_):
                                alertController.message = "Invalid username or password"
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                }else{
                }
            }
        }else{
        }
    }
}
//MARK: - Extension GIDSignInDelegate
extension LoginViewController: GIDSignInDelegate{
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
        let idToken = user.authentication.idToken ?? "" // Safe to send to the server
        let givenName = user.profile.givenName ?? ""
        let familyName = user.profile.familyName ?? ""
        let email = user.profile.email ?? ""
        APIManager().googleSingIn(username: email , token: idToken , firstName: givenName , lastName: familyName) { (result) in
            switch result {
            case .success(let id):
                UserDefaults.standard.set(id, forKey: K.userIdKey)
                APIManager().getProfileInfo(authorization: idToken ) { (result) in
                    switch result {
                    case .success(let profileInfo):
                        UserDefaults.standard.set(profileInfo.first_name, forKey: K.userFirstNameKey)
                        UserDefaults.standard.set(profileInfo.last_name, forKey: K.userLastNameKey)
                        UserDefaults.standard.set(profileInfo.user_type, forKey: K.userTypeKey)
                        UserDefaults.standard.set(idToken, forKey: K.token)
                        UserDefaults.standard.setValue(true, forKey: K.isGoogleSignedInKey)
                        UserDefaults.standard.set(profileInfo.email, forKey: K.usernameKey)
                        UserDefaults.standard.set(true, forKey: K.isLoggedinKey)
                        self.isLoggedIn = true
                        self.dismiss(animated: true, completion: nil)
                    case .failure(_): break
                    }
                }
            case .failure(_): break
            }
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        UserDefaults.standard.set(false, forKey: K.isLoggedinKey)
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
