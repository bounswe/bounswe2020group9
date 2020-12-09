//
//  ListCell.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 7.12.2020.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet var listNameLabel: UILabel!
    @IBOutlet var productImagesStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
