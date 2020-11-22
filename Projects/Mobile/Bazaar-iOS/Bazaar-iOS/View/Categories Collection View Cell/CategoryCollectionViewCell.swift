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
    
    var delegate: CellDelegate?
    var categoryId: Int?
    
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
    
    func setCategory(id: Int, categoryName: String) {
        self.categoryId = id
        self.categoryNameLabel.text = categoryName
    }
    
    @objc func cellTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.didCellSelected(cell: self)
    }
}
