//
//  CreditCardCell.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 20.01.2021.
//

import UIKit

class CreditCardCell: UITableViewCell {
    
    @IBOutlet weak var creditCardCellView: CreditCardCell!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var cellDeleteButton: UIButton!
    
    
    func setCreditCard(name:String , cardNumber:String, deadline:String, cvv:String, index:Int) -> CreditCardCell {
        
        self.nameLabel.text = name
        self.cardNumberLabel.text = cardNumber
        self.deadlineLabel.text = deadline
        self.cvvLabel.text = cvv
        self.cellDeleteButton.setTitle("\(index)", for: .normal)
        self.creditCardCellView.layer.shadowColor = UIColor.black.cgColor
        self.creditCardCellView.layer.shadowOpacity = 0.2
        self.creditCardCellView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.creditCardCellView.layer.shadowRadius = 3
        return self
    }
    
    @IBAction func cellDeleteButtonPressed(_ sender: UIButton) {
    }
}
