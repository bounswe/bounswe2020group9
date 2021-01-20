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
    
    func setCreditCard(cardId:Int, name:String , cardNumber:String, deadline:String, cvv:String) -> CreditCardCell {
        self.cardId = cardId
        self.nameLabel.text = name
        self.cardNumberLabel.text = cardNumber
        self.deadlineLabel.text = deadline
        self.cvvLabel.text = cvv
        self.creditCardCellView.layer.shadowColor = UIColor.black.cgColor
        self.creditCardCellView.layer.shadowOpacity = 0.2
        self.creditCardCellView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.creditCardCellView.layer.shadowRadius = 3
        return self
    }
    
    @IBAction func cellDeleteButtonPressed(_ sender: UIButton) {
        self.delegate?.creditCardCellDidDeleteButtonPressed(cell: self)
    }
}
