//
//  User.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.11.2020.
//

import Foundation

struct User {
    let id:Int
    let username:String
    let first_name: String
    let last_name:String
    let email:String
    
    init(id:Int,userName:String,firstName:String,lastName:String,email:String) {
        self.id = id
        self.username = userName
        self.first_name = firstName
        self.last_name = lastName
        self.email = email
    }
}
