//
//  CategoriesCollectionViewCell.swift
//  Bazaar-iOS
//
//  Created by alc on 19.11.2020.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.categoryButton.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.00)
        self.categoryButton.setTitleColor(UIColor.darkGray, for: .normal)
    }

    func configure (with category: String) {
        self.categoryButton.setTitle(category, for: .normal)
        self.categoryButton.setTitle(category, for: .selected)
        self.categoryButton.layer.cornerRadius = 5
        self.categoryButton.sizeToFit()
        

        
    }
    
    @IBAction func categoryClicked(_ sender: Any) {
        

        if categoryButton.isSelected {
            self.categoryButton.backgroundColor = UIColor(red: 0.96, green: 0.65, blue: 0.19, alpha: 1.00)//Choose your colour here
            self.categoryButton.setTitleColor(UIColor.white, for: .normal) //To change button Title colour .. check your button Tint color is clear_color..
            self.isSelected = false
            categoryButton.isSelected = false
            categoryButton.isEnabled = false
        } else {
            self.categoryButton.backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.00)
            self.categoryButton.setTitleColor(UIColor.darkGray, for: .normal)
            self.isSelected = true
            categoryButton.isSelected = true
        }
    }
    
    
}
