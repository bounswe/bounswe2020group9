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
    
    /*
     function that contains the initialization code for SearchHistoryTableViewCell
     */
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /*
     function that contains the code for configuring the SearchHistoryTableViewCell for the selected state
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*
     function for hiding the clock imageview used for search history items
     */
    func hideClock() {
       clockImage.isHidden = true
    }

    /*
     function for showing the clock imageview used for search history items
     */
    func showClock() {
         clockImage.isHidden = false
    }
    
    /*
     function for hiding the type name (vendor, category, brand etc.) used for search history items
     */
    func hideType() {
        typeLabel.isHidden = true
    }
    
    /*
     function for showing the type name (vendor, category, brand etc.) used for search history items
     */
    func showType() {
        typeLabel.isHidden = false
        typeLabel.text = "Category"
    }
}
