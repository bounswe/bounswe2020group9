//
//  MyCreditCardsViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 20.01.2021.
//

import UIKit

class MyCreditCardsViewController: UIViewController {
    
    @IBOutlet weak var creditCardsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        creditCardsTableView.layer.borderColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0, alpha: 1)
        self.creditCardsTableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
}
