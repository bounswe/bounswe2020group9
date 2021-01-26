//
//  OrderCell.swift
//  Bazaar-iOS
//
//  Created by Uysal, Sadi on 22.01.2021.
//

import UIKit

protocol TableViewNewProtocol {
    func buttonClicked(index:Int)
}

class OrderCell: UITableViewCell {

    @IBOutlet weak var Cancel_OrderButton: UIButton!
    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var Name_BrandLabel: UILabel!
    @IBOutlet weak var Price_StatusLabel: UILabel!
    @IBOutlet weak var VendorLabel: UILabel!
    @IBOutlet weak var DatesLabel: UILabel!
    @IBOutlet weak var AmountLabel: UILabel!
    @IBOutlet weak var AdressLabel: UILabel!
    var cellDelegate:TableViewNewProtocol?
    var index:IndexPath?
    var delivery_id:Int!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        cellDelegate?.buttonClicked(index:(index?.row)!)
    }
}
