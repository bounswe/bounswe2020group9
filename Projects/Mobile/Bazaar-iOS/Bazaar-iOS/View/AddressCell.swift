//
//  AddressCell.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.01.2021.
//

import UIKit

protocol AddressCellDelegate {
    func  addressCellDidDeleteButtonPressed(cell:AddressCell)
    func  addressCellDidUpdateButtonPressed(cell:AddressCell)
}

class AddressCell: UITableViewCell {
    var delegate: AddressCellDelegate?
    var addressId:Int?
    var user: Int?
    var latitude:Float?
    var longitude:Float?
    
    @IBOutlet weak var addressCellView: AddressCell!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var fullAddressLabel: UILabel!
    
    func setAddress(addressId:Int, addressName:String , openAddress:String, country:String, city:String, postalCode:Int,latitude:Float, longitude:Float, user:Int) -> AddressCell {
        self.addressId = addressId
        self.addressNameLabel.text = addressName
        self.fullAddressLabel.text = openAddress
        self.countryNameLabel.text = country
        self.cityNameLabel.text = city
        self.postalCodeLabel.text = "\(postalCode)"
        self.latitude = latitude
        self.longitude = longitude
        self.user = user
        self.addressCellView.layer.shadowColor = UIColor.black.cgColor
        self.addressCellView.layer.shadowOpacity = 0.5
        self.addressCellView.layer.shadowRadius = 3
        return self
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        self.delegate?.addressCellDidUpdateButtonPressed(cell: self)
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        self.delegate?.addressCellDidDeleteButtonPressed(cell: self)
    }
}
