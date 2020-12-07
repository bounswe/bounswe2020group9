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
    let email:String
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
//{
//    "id": 1,
//    "last_login": "2020-11-23T07:51:49Z",
//    "is_superuser": false,
//    "username": "tunaTugcu@bazaar.com",
//    "first_name": "Tuna",
//    "last_name": "Tuğcu",
//    "email": "tunaTugcu@bazaar.com",
//    "is_staff": false,
//    "is_active": true,
//    "date_joined": "2020-11-18T12:49:51Z",
//    "user_type": 2,
//    "bazaar_point": 0,
//    "groups": [],
//    "user_permissions": []
//}
