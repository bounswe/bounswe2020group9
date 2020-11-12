//
//  MainTabBarController.swift
//  Bazaar-iOS
//
//  Created by alc on 12.11.2020.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        //setupTabBar()
                
        //setTabBarImages()
                
        //setTabBarTitles()
        // Do any additional setup after loading the view.
    }
    
    func setupTabBar () {
        let mainScreenStoryboard = UIStoryboard(name: "mainScreen", bundle: nil).instantiateViewController(withIdentifier: "mainScreenViewController")

        let mainScreenViewController = UINavigationController(rootViewController: mainScreenStoryboard)

        viewControllers = [mainScreenViewController]

        //guard let items = tabBar.items else { return }
        //for item in items {
        //    item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        //}
        
        //mainScreenViewController.tabBarItem.image = UIImage(systemName: "line.horizontal.3")?.withTintColor(UIColor.gray)
        //mainScreenViewController.tabBarItem.selectedImage = UIImage(systemName: "line.horizontal.3")?.withTintColor(UIColor.blue)
        //mainScreenViewController.tabBarItem.title = "Kategoriler"

    }
    
    func setTabBarImages () {
        
    }
    
    func setTabBarTitles () {
    }
    
    // MARK: UITabBarDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      if viewController.isKind(of: ViewController.self) {
         let vc =  ViewController()
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
