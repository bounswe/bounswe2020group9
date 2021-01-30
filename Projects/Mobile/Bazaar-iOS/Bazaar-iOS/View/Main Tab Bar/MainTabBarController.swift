//
//  MainTabBarController.swift
//  Bazaar-iOS
//
//  Created by Alcan Ünsal on 12.11.2020.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    /*
     function for doing any additional setup after loading the view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    /*
     function that sets up the tab bar with view controllers
     */
    func setupTabBar () {
        let mainScreenStoryboard = UIStoryboard(name: "mainScreen", bundle: nil).instantiateViewController(withIdentifier: "mainScreenViewController")

        let mainScreenViewController = UINavigationController(rootViewController: mainScreenStoryboard)

        viewControllers = [mainScreenViewController]
    }
    
    func setTabBarImages () {
        
    }
    
    func setTabBarTitles () {
    }
    
    // MARK: UITabBarDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      if viewController.isKind(of: MainViewController.self) {
         let vc =  MainViewController()
         vc.modalPresentationStyle = .overFullScreen
         self.present(vc, animated: true, completion: nil)
         return false
      }
      return true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
