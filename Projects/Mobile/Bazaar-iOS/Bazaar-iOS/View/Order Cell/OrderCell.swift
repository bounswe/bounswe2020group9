//
//  OrderCell.swift
//  Bazaar-iOS
//
//  Created by Uysal, Sadi on 22.01.2021.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var Name_BrandLabel: UILabel!
    @IBOutlet weak var Price_StatusLabel: UILabel!
    @IBOutlet weak var VendorLabel: UILabel!
    @IBOutlet weak var DatesLabel: UILabel!
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var AdressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
