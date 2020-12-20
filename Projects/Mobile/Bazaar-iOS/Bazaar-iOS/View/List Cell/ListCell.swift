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
    @IBOutlet var productImages: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(pictureUrls: [Int:[String]], listName: String, listID: Int) {
        self.listNameLabel.text = listName
        if let pics = pictureUrls.values.first {
            for i in 0..<pics.count {
                let theImageView = self.productImages[i]
                theImageView.translatesAutoresizingMaskIntoConstraints = false
                if listID == pictureUrls.keys.first {
                    DispatchQueue.main.async {
                        do {
                            try theImageView.loadImageUsingCache(withUrl: pics[i])
                        } catch let error {
                            print(error)
                        }
                    }
                }
                theImageView.frame = CGRect(x: 0, y: 0, width: self.productImagesStack.frame.height, height: self.productImagesStack.frame.height)
                theImageView.translatesAutoresizingMaskIntoConstraints = false
                let marginguide = self.contentView.layoutMarginsGuide
                theImageView.heightAnchor.constraint(equalToConstant: marginguide.layoutFrame.height).isActive = true
                theImageView.widthAnchor.constraint(equalToConstant: marginguide.layoutFrame.height).isActive = true
                theImageView.contentMode = .scaleAspectFit
            }
        }
    }
    
}
