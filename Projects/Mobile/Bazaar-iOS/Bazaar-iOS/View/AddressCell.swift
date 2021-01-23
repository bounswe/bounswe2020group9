//
//  AddressCell.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.01.2021.
//

import UIKit

class AddressCell: UITableViewCell {
    
    var addressId:Int?
    var user: Int?
    var latitude:Float?
    var longitude:Float?
    
    @IBOutlet weak var addressCellView: AddressCell!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var openAddressLabel: UILabel!
    
    func setAddress(addressId:Int, addressName:String , openAddress:String, country:String, city:String, postalCode:Int,latitude:Float, longitude:Float, user:Int) -> AddressCell {
        self.addressId = addressId
        self.addressNameLabel.text = addressName
        self.openAddressLabel.text = openAddress
        self.countryNameLabel.text = country
        self.cityNameLabel.text = city
        self.postalCodeLabel.text = "\(postalCode)"
        self.latitude = latitude
        self.longitude = longitude
        self.user = user
        self.addressCellView.layer.shadowColor = UIColor.black.cgColor
        self.addressCellView.layer.shadowOpacity = 0.2
        self.addressCellView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.addressCellView.layer.shadowRadius = 3
        return self
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
    }
}
