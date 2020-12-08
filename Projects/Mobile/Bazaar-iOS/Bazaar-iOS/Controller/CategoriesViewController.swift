//
//  SearchViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 12.11.2020.
//

import UIKit

class CategoriesViewController:UIViewController  {
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print(searchTextField.text)
    }
}
