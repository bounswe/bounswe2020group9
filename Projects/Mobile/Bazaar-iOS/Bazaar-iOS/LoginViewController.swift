//
//  LoginViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 18.11.2020.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var frameView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        frameView.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        frameView.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "loginToSignUp", sender: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        
        var loginSuccessful = false
        if let email = emailTextField.text {
            if !email.isEmail {
                alertController.message = "Your email address is invalid. Please enter a valid address."
                self.present(alertController, animated: true, completion: nil)
                loginSuccessful = false
            }else{
                if let password = passwordTextField.text{
                    if password.count < 8 || password.count > 20 {
                        alertController.message = "Password must be at least 8 , at most 20 characters in length"
                        self.present(alertController, animated: true, completion: nil)
                        loginSuccessful = false
                    }else {
                        loginSuccessful = true
                    }
                }else{
                    loginSuccessful = false
                }
            }
        }else{
        }
    }
}

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
