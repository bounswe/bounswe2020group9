//
//  MainTabBarControllerViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 12.11.2020.
//

import UIKit

class MainTabBarControllerViewController: UITabBarController, UITabBarControllerDelegate {

    var mainScreenViewController: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScreenViewController = ViewController()
        // Do any additional setup after loading the view.
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
