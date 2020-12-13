//
//  APIDatas.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.11.2020.
//

import Foundation

struct LoginData : Codable{
    let id:Int
    let username:String
    let first_name: String
    let last_name:String
    let email:String
}

struct AuthData:Codable {
    let token:String
    let user_id:Int
    let user_type:Int
}

struct SignUpData:Codable {
    let message:String
}

struct ProductData: Codable {
    let id: Int
    let name: String
    let brand:  String
    let labels: [String]
    let categories: [String]
    //let subcategory: String
    let price: Double
    let stock: Int
    let sell_counter: Int
    let rating: Double
    let vendor: Int
    let picture: String?
}
