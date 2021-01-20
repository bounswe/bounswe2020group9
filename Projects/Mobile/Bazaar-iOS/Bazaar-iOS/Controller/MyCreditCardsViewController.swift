//
//  MyCreditCardsViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 20.01.2021.
//

import UIKit

class MyCreditCardsViewController: UIViewController{
    
    @IBOutlet weak var creditCardsTableView: UITableView!
    var creditCardsArray:[CreditCardData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        creditCardsTableView.layer.borderColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0, alpha: 1)
        self.creditCardsTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        creditCardsArray.append(CreditCardData(cardId: 1, name: "Muhsin Etki", cardNumber: "1234 5678 9012 3456", deadline: "11/24", cvv: "123"))
        creditCardsArray.append(CreditCardData(cardId: 2, name: "Muhsin Etki2", cardNumber: "0000 5678 9012 3456", deadline: "01/25", cvv: "321"))
        self.creditCardsTableView.dataSource = self
    }
}
//MARK: - Extension
extension MyCreditCardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CreditCardCell", for: indexPath) as! CreditCardCell
        let creditCardData = self.creditCardsArray[indexPath.row]
        cell = cell.setCreditCard(cardId: creditCardData.cardId, name: creditCardData.name, cardNumber: creditCardData.cardNumber, deadline: creditCardData.deadline, cvv: creditCardData.cvv)
        cell.delegate=self
        return cell
    }
}
//MARK: - CreditCardCellDelegate
extension MyCreditCardsViewController: CreditCardCellDelegate {
    func creditCardCellDidDeleteButtonPressed(cell: CreditCardCell) {
        if let index = self.creditCardsArray.firstIndex(where: {$0.cardId == cell.cardId}){
            DispatchQueue.main.async {
                self.creditCardsArray.remove(at: index)
                self.creditCardsTableView.reloadData()
            }
        }
    }
}
