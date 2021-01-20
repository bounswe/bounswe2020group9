//
//  MyCreditCardsViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 20.01.2021.
//

import UIKit

class MyCreditCardsViewController: UIViewController{
    
    @IBOutlet weak var creditCardsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        creditCardsTableView.layer.borderColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0, alpha: 1)
        self.creditCardsTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        //load data
        self.creditCardsTableView.dataSource = self
    }
}
//MARK: - Extension
extension MyCreditCardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardCell", for: indexPath) as! CreditCardCell
        

        cell = cell.setCreditCard(name: "Muhsin Etki", cardNumber: "1234 5678 9012 3456", deadline: "12/24", cvv: "123", index: 1)
                
            //cell.delegate=self
        
        return cell
    }
    
    
}
