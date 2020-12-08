//
//  SearchHistoryTableViewCell.swift
//  Bazaar-iOS
//
//  Created by alc on 8.12.2020.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func hideClock() {
       clockImage.isHidden = true
    }

    func showClock() {
         clockImage.isHidden = false
    }
    
    func hideType() {
        typeLabel.isHidden = true
    }
    
    func showType() {
        typeLabel.isHidden = false
        typeLabel.text = "Category"
    }
}
