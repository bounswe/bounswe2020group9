//
//  CartTableViewCell.swift
//  Bazaar-iOS
//
//  Created by alc on 19.12.2020.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountStepper: UIStepper!
    
    var product: ProductData!
    var amountChangedDelegate: CartItemAmountChangedDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        amountStepper.minimumValue = 1
        // amountStepper.maximumVaule = stock **
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func changeAmount(_ sender: UIStepper) {
        let quantity = Int(sender.value)
        APIManager().editAmountInCart(productID: product!.id, amount: quantity, completionHandler: { result in
            switch result {
            case .success(let cart):
                self.amountTextField.text = String(quantity)
                if let mycartVC = self.amountChangedDelegate as? MyCartViewController {
                    mycartVC.userCart = cart
                }
                self.amountChangedDelegate.amountChangedForItem(product: self.product, amount: quantity)
            case .failure(let error):
                print(error)
            }
        })
    }
    
}

protocol CartItemAmountChangedDelegate {
    func amountChangedForItem(product: ProductData, amount: Int)
}
