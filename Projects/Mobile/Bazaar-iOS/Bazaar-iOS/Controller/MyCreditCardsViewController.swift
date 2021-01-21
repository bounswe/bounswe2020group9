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
        self.creditCardsTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager().getCreditCards { (result) in
            switch result{
            case .success(let creditCards):
                print(creditCards)
                self.creditCardsArray = creditCards
                self.creditCardsTableView.reloadData()
            case .failure(_):
                print("olmadi")
            }
        }
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
        cell = cell.setCreditCard(cardId: creditCardData.id, name: creditCardData.name_on_card, cardNumber: creditCardData.card_id, dateMonth: creditCardData.date_month , dateYear: creditCardData.date_year, cvv: creditCardData.cvv, cardName: creditCardData.card_name)
        cell.delegate=self
        return cell
    }
}
//MARK: - CreditCardCellDelegate
extension MyCreditCardsViewController: CreditCardCellDelegate {
    func creditCardCellDidDeleteButtonPressed(cell: CreditCardCell) {
        if let index = self.creditCardsArray.firstIndex(where: {$0.id == cell.cardId}){
            DispatchQueue.main.async {
                self.creditCardsArray.remove(at: index)
                self.creditCardsTableView.reloadData()
            }
        }
    }
}
