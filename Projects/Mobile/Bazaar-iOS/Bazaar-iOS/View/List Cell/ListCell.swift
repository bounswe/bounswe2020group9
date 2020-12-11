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
    @IBOutlet var frameView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /*
    override func layoutSubviews() {
        super.layoutSubviews()
        //frameView.layer.cornerRadius = 5
        frameView.layer.borderWidth = 0.8
        frameView.layer.borderColor = #colorLiteral(red: 0.9995815158, green: 0.6448794603, blue: 0.3569172323, alpha: 1)
        frameView.layer.shadowColor = UIColor.black.cgColor
        frameView.layer.shadowOffset = CGSize(width: 2, height: 2)
        frameView.layer.shadowOpacity = 0.4
        frameView.layer.shadowRadius = 2.0
        
    }*/
    
}
