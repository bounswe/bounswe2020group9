//
//  CategoryCollectionViewCell.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 22.11.2020.
//

import  UIKit

protocol CellDelegate {
    func didCellSelected(cell: UICollectionViewCell)
}

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var collectionViewCell: UICollectionViewCell!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    var delegate: CellDelegate?
    var categoryName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        self.addGestureRecognizer(tap)
        collectionViewCell = loadViewFromNib()
        collectionViewCell.frame = bounds
        collectionViewCell.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.backgroundColor = UIColor.clear
        addSubview(collectionViewCell)
    }
    
    func loadViewFromNib() -> UICollectionViewCell {
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle(for: CategoryCollectionViewCell.self))
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UICollectionViewCell
        return view
    }
    
    func setCategory(categoryName: String) {
        self.categoryNameLabel.text = categoryName
        self.categoryName = categoryName
    }
    func setAsCurrentCategory(isCurrentCategory: Bool) {
        if isCurrentCategory {
            self.cellBackgroundView.backgroundColor = #colorLiteral(red: 0.9664689898, green: 0.6368434429, blue: 0.1475634575, alpha: 1)
        }else {
            self.cellBackgroundView.backgroundColor = #colorLiteral(red: 0.5568061471, green: 0.5569032431, blue: 0.5782801509, alpha: 0.5684128853)
        }
    }
    
    @objc func cellTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.didCellSelected(cell: self)
        
    }
}
