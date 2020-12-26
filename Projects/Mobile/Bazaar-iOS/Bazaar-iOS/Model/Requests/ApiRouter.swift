//
//  APIRequest.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.11.2020.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestBuilder {
    
    case authenticate(username: String, password: String)
    case getCustomerLists(userId: Int, isCustomerLoggedIn: Bool)
    case addList(name: String, userId: Int, isPrivate: Bool)
    case deleteList(userId: Int, id: String)
    case deleteProductFromList(userId: Int, list_id: String, product_id: String)
    case editList(userId:Int, list: String, newName: String, newIsPrivate: String)
    case addToList(userId:Int, list_id: Int, product_id: Int)
    case signUpCustomer(firstName:String,lastName:String,username:String, password:String, user_type:String)
    case signUpVendor(firstName:String, lastName:String, username:String, password:String, user_type:String,addressName:String, address:String, postalCode:Int, latitude:Float, lontitude:Float, companyName:String)
    case resetPasswordEmail(username:String)
    case updatePassword(userId:Int,currentPassword:String, newPassword:String)
    case getCart(user: Int)
    case addToCart(user: Int, productID: Int, amount: Int)
    case editAmountInCart(productID: Int, amount: Int)
    case deleteProductFromCart(productID: Int)
    case getProfileInfo(authorization:String)
    case setProfileInfo(authorization:String, firstName:String, lastName:String)
    case googleSignIn(userName:String, token:String, firstName:String, lastName:String)

  // MARK: - Path
    internal var path: String {
        switch self {
        case .authenticate:
            return "api/user/login/"
        case .getCustomerLists(let userId, _):
            return "api/user/\(userId)/lists/"
        case .addList(_, let userId, _):
            return "api/user/\(userId)/lists/"
        case .deleteList(let userId, let id):
            return "api/user/\(userId)/list/\(id)/"
        case .deleteProductFromList(let userId, let list_id, _):
            return "api/user/\(userId)/list/\(list_id)/edit/"
        case .editList(let userId, let list, _,_):
            return "api/user/\(userId)/list/\(list)/"
        case .addToList(let userId, let list_id, _):
            return "api/user/\(userId)/list/\(list_id)/edit/"
        case .signUpCustomer , .signUpVendor:
            return "api/user/signup/"
        case .resetPasswordEmail:
            return "api/user/resetpwmail/"
        case .getCart(_):
            //return "api/user/"+user+"/cart/"
            return "api/user/cart/"
        case .addToCart(_,  _,  _):
            return "api/user/cart/"
        case .editAmountInCart( _,  _):
            return "api/user/cart/"
        case .deleteProductFromCart(_):
            return "api/user/cart/"
        case .getProfileInfo:
            return "api/user/profile/"
        case .setProfileInfo:
            return "api/user/profile/"
        case .updatePassword:
            return "api/user/resetpwprofile/"
        case .googleSignIn:
            return "api/user/googleuser/"
        }
        
    }

    // MARK: - Parameters
    internal var parameters: Parameters? {
        var params = Parameters.init()
        switch self {
        case .authenticate(let username, let password):
            params["username"] = username
            params["password"] = password
        case .addList(let name, let customer, let isPrivate):
            params["name"] = name
            params["customer"] = customer
            params["is_private"] = isPrivate
        case .deleteProductFromList(_, _, let product_id):
            params["product_id"] = product_id
        case .editList(_, _, let name, let isPrivate):
            params["name"] = name
            params["is_private"] = isPrivate
        case .addToList(_,_, let product_id):
            params["product_id"] = String(product_id)
        case .signUpCustomer(let firstName, let lastName, let username, let password, let user_type):
            params["first_name"] = firstName
            params["last_name"] = lastName
            params["username"] = username
            params["password"] = password
            params["user_type"] = user_type
        case .resetPasswordEmail(let username):
            params["username"] = username
        case .addToCart(_, let productID, let amount):
            params["product_id"] = productID
            params["amount"] = amount
        case .editAmountInCart(let productID, let amount):
            params["product_id"] = productID
            params["amount"] = amount
        case .deleteProductFromCart(let productID):
            params["product_id"] = productID
        case .setProfileInfo( _, let firstName, let lastName):
            params["first_name"] = firstName
            params["last_name"] = lastName
        case .updatePassword(let userID , let currentPassword, let newPassword):
            params["user_id"] = userID
            params["old_password"] = currentPassword
            params["new_password"] = newPassword
        case .googleSignIn(let userName, let token, let firstName, let lastName):
            params["username"] = userName
            params["token"] = token
            params["first_name"] = firstName
            params["last_name"] = lastName
        case .signUpVendor(let firstName, let lastName, let username, let password, let user_type, let addressName, let address, let postalCode, let latitude, let lontitude, let companyName):
            params["first_name"] = firstName
            params["last_name"] = lastName
            params["username"] = username
            params["password"] = password
            params["user_type"] = user_type
            params["address_name"] = addressName
            params["address"] = address
            params["postal_code"] = postalCode
            params["latitude"] = latitude
            params["longitude"] = lontitude
            params["company"] = companyName
        default:
            break
        }
        return params
    }
    // MARK: - Headers
    internal var headers: HTTPHeaders? {
        var headers = HTTPHeaders.init()
        switch self {
        case .authenticate, .googleSignIn, .signUpCustomer, .signUpVendor, .resetPasswordEmail, .updatePassword:
            headers["Accept"] = "application/json"
        case .getCustomerLists(_, let isCustomerLoggedIn):
            if isCustomerLoggedIn {
                headers["Authorization"] = "Token " +  (UserDefaults.standard.value(forKey: K.token) as! String)
            }
        case .addList, .deleteList, .deleteProductFromList , .editList, .addToList:
            headers["Authorization"] = "Token " +  (UserDefaults.standard.value(forKey: K.token) as! String)
        case .getCart, .addToCart, .editAmountInCart, .deleteProductFromCart:
            headers["Authorization"] = "Token " +  (UserDefaults.standard.value(forKey: K.token) as! String)
        case .getProfileInfo(let authorization):
            headers["Authorization"] = "Token \(authorization)"
        case .setProfileInfo(let authorization,_,_):
            headers["Authorization"] = "Token \(authorization)"
        }
        return headers
    }
    
    // MARK: - Methods
    internal var method: HTTPMethod {
        switch self {
        case .authenticate, .addList,.addToList, .signUpCustomer, .signUpVendor, .resetPasswordEmail, .addToCart,.updatePassword, .googleSignIn:
            return .post
        case .getCustomerLists, .getCart,.getProfileInfo:
            return .get
        case .deleteList, .deleteProductFromList,.deleteProductFromCart:
            return .delete
        case .editList,.editAmountInCart,.setProfileInfo:
            return .put
        }
    }
}
