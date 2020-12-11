//
//  ProfileViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 22.11.2020.
//

import UIKit
import GoogleSignIn

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var profileMenu: UITableView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileMenu.delegate = self
        profileMenu.dataSource = self
        profileMenu.layer.cornerRadius = 10
        profileMenu.layer.borderColor = UIColor.orange.cgColor
        profileMenu.layer.borderWidth = 0.5
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
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if let selectionIndexPath = profileMenu.indexPathForSelectedRow {
                profileMenu.deselectRow(at: selectionIndexPath, animated: false)
            }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLayoutSubviews()
        let topInset = max((profileMenu.frame.height - profileMenu.contentSize.height) / 2.0, 0.0)
        profileMenu.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
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

//MARK: - UITableViewDelegate,UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Menu Cell \(indexPath.row)", for: indexPath)
        let selectedView = UIView()
        selectedView.backgroundColor = #colorLiteral(red: 0.9402856827, green: 0.6186184287, blue: 0.1447118819, alpha: 0.4013809419)
        selectedView.layer.cornerRadius = 10
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return profileMenu.frame.height / 7
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
