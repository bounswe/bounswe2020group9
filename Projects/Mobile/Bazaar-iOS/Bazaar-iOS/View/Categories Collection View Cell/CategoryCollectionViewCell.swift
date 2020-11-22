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
            self.cellBackgroundView.backgroundColor = #colorLiteral(red: 0, green: 0.7545160055, blue: 0.850833118, alpha: 1)
        }else {
            self.cellBackgroundView.backgroundColor = #colorLiteral(red: 0.3393321633, green: 0.4168884754, blue: 0.9809423089, alpha: 1)
        }
    }
    
    @objc func cellTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.didCellSelected(cell: self)
        
    }
}
