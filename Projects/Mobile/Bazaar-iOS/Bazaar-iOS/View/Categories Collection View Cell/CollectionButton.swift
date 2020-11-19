//
//  CollectionButton.swift
//  Bazaar-iOS
//
//  Created by alc on 19.11.2020.
//

import UIKit

class CollectionButton: UIButton {

    override var isSelected: Bool {
        didSet {
            
            if isHighlighted || isSelected {
                backgroundColor = UIColor(red: 0.96, green: 0.65, blue: 0.19, alpha: 1.00)
                setTitleColor(UIColor.white, for: .highlighted)
                setTitleColor(UIColor.white, for: .selected)
                setTitleColor(UIColor.white, for: .normal)
            } else {
                backgroundColor = UIColor(red: 0.86, green: 0.85, blue: 0.85, alpha: 1.00)
                setTitleColor(UIColor.darkGray, for: .normal)
                setTitleColor(UIColor.darkGray, for: .selected)
                setTitleColor(UIColor.darkGray, for: .highlighted)
            }
                
            
            
            
        }
    }
    

}
