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

struct ResetPassWordEmailData:Codable {
    let message:String
}


struct ProductData: Codable, Equatable {
    static func == (lhs: ProductData, rhs: ProductData) -> Bool {
        return lhs.id == rhs.id
    }
    
  let id:Int
  let name: String
  let brand: String
  let labels: [String]
  let detail: String
  let category: Category
  let price: Double
  let stock: Int
  let sell_counter: Int
  let rating: Double
  let vendor: Int
  let picture: String?
  struct Category: Codable {
    let name: String
    let parent: String?
    let id: Int
  }
}

struct CustomerListData: Codable {
    let id: Int
    let name: String
    let customer: Int
    var products: [ProductData]
    let is_private: Bool
}

struct ListDeleteMessage: Codable{
    let message: String
}

struct Cart: Codable {
    let cart: [CartProduct]
}

struct CartProduct: Codable {
    let id: Int
    let amount: Int
    let product: Int
    let customer: Int
}

 struct ProfileData:Codable {
    let id: Int
    let email:String
    let first_name:String
    let last_name:String
    let user_type:Int
    let bazaar_point:Int
}

struct UpdatePasswordData:Codable {
    let message:String
}

struct CommentData: Codable {
    let id: Int
    let timestamp: String
    let body: String
    let rating: Int
    let is_anonymous: Bool
    let customer: Int!
    let product: Int
    let first_name: String!
    let last_name: String!
    let user_type: Int!
    let bazaar_point: Int!
    let company: String!
}
struct SearchProduct:Codable {
    let id: Int
    let name: String
    let detail: String
    let brand: String
    let price: Double
    let stock: Int
    let rating: Double
    let sell_counter: Int
    let release_date: String
    let picture: String
    let category_id: Int
    let vendor_id: Int?
}

struct SearchProductList:Codable {
    let product_list:[SearchProduct]
}

  struct GoogleSignInData:Codable {
    let id:Int
}

struct VendorData: Codable {
    let id:Int
    let email:String
    let first_name:String
    let last_name:String
    let date_joined:String
    let last_login:String?
    let user_type:Int
    let bazaar_point:Double
    let company:String
}
struct OrderData_Cust: Codable {
    let id:Int
    let customer_id:Int
    let timestamp:String
    let deliveries:[DeliveryData]
}
struct DeliveryData: Codable {
    let id:Int
    let product_id:Int
    let timestamp:String
    let delivery_time:String
    let current_status:Int
    let order_id:Int
    let customer_id:Int
    let amount:Int
    let vendor:Int
    let delivery_address:AddressData
}

struct CreditCardData:Codable {
    let id:Int
    let name_on_card:String
    let card_id:String
    let date_month:String
    let date_year:String
    let cvv:String
    let card_name:String
}

struct removeCreditCardData: Codable{
    let message: String
}


struct OrderData:Codable {
    let product:Int
    let amount:Int
    let timestamp:String
    let customer:Int
    let order:Int
    let delivery_time:String
}

struct AddressData:Codable {
    let id:Int
    let address_name:String
    let address:String
    let country:String
    let city:String
    let postal_code:Int
    let longitude:Float
    let latitude:Float
    let user_id:Int
}
struct VendorOrderData: Codable {
    let id:Int
    let product_id:Int
    let timestamp:String
    let delivery_time:String
    let current_status:Int
    let order_id:Int
    let customer_id:Int
    let amount:Int
    let delivery_address:AddressData
}
