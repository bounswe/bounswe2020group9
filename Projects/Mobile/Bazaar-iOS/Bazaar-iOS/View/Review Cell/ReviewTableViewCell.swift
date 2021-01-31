//
//  ReviewTableViewCell.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 25.12.2020.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var commentTimeLabel: UILabel!
    @IBOutlet weak var commentBody: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
