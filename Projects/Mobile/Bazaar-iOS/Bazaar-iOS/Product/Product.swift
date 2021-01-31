//
//  Product.swift
//  Bazaar-iOS
//
//  Created by Alcan Ünsal on 19.11.2020.
//

import Foundation

/*
 Class for representing a product, initially used but unused now.
 */
class Product {
    
    var title: String
    var brand: String
    var category: String
    var price: String
    var photo: String
    
    init(title: String, brand: String, category: String, price: String, photo: String) {
        self.title = title
        self.brand = brand
        self.category = category
        self.price = price
        self.photo = photo
    }
}
