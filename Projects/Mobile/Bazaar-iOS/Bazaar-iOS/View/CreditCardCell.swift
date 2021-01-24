//
//  CreditCardCell.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 20.01.2021.
//

import UIKit

protocol CreditCardCellDelegate {
    func  creditCardCellDidDeleteButtonPressed(cell:CreditCardCell)
}

class CreditCardCell: UITableViewCell {
    var cardId:Int?
    var delegate:CreditCardCellDelegate?
    @IBOutlet weak var creditCardCellView: CreditCardCell!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    
    func setCreditCard(cardId:Int, name:String , cardNumber:String, dateMonth:String, dateYear:String, cvv:String,cardName:String) -> CreditCardCell {
        self.cardId = cardId
        self.nameLabel.text = name
        self.cardNumberLabel.text = "\(cardNumber.prefix(4)) **** **** **\(cardNumber.suffix(2))"
        self.deadlineLabel.text = "\(dateMonth)/\(dateYear)"
        self.cvvLabel.text = "\(cvv.prefix(1))**"
        self.cardNameLabel.text = cardName
        self.creditCardCellView.layer.shadowColor = UIColor.black.cgColor
        self.creditCardCellView.layer.shadowOpacity = 0.5
        self.creditCardCellView.layer.shadowRadius = 3
        return self
    }
    
    @IBAction func cellDeleteButtonPressed(_ sender: UIButton) {
        self.delegate?.creditCardCellDidDeleteButtonPressed(cell: self)
    }
}
