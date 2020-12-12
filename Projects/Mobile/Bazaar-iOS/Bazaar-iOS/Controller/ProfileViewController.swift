//
//  ProfileViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 22.11.2020.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var userEmailLabel: UILabel!

    @IBOutlet var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        menuView.layer.borderColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let isLoggedIn =  UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool {
            if !isLoggedIn {
                self.view.isHidden = true
                performSegue(withIdentifier: "ProfileToLoginSegue", sender: self)
            }else {
                self.view.isHidden = false
            }
        }else {
            self.view.isHidden = true
            performSegue(withIdentifier: "ProfileToLoginSegue", sender: self)
        }
    }

    
    @IBAction func temporaryLogoutButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: K.isLoggedinKey)
        GIDSignIn.sharedInstance().signOut()
        performSegue(withIdentifier:"ProfileToLoginSegue" , sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileToLoginSegue" {
            if let destinationVC = segue.destination as? LoginViewController {
                destinationVC.delegate = self
            }
        }else if segue.identifier == "ProfileToSignUpSegue" {
            if let destinationVC = segue.destination as? SignUpViewController {
                destinationVC.delegate = self
            }
        }
    }
}

//MARK: - Extension LoginViewControllerDelegate
extension ProfileViewController: LoginViewControllerDelegate{
    func loginViewControllerDidPressSignUp(isPressed: Bool) {
        if isPressed {
            performSegue(withIdentifier:"ProfileToSignUpSegue" , sender: nil)
        }
    }
    
    func loginViewControllerDidPressContinueAsGuest(isPressed: Bool) {
        if isPressed {
            self.tabBarController?.selectedViewController = self.tabBarController?.children[0]
        }
    }
}
//MARK: - Extension SignUpViewControllerDelegate
extension ProfileViewController: SignUpViewControllerDelegate{
    func signUpViewControllerDidPressLoginHere() {
        performSegue(withIdentifier:"ProfileToLoginSegue" , sender: nil)
    }
}
