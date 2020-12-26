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
    case signUp(username:String, password:String, user_type:String)
    case resetPasswordEmail(username:String)
    case updatePassword(userId:Int,currentPassword:String, newPassword:String)
    case getCart(user: Int)
    case addToCart(user: Int, productID: Int, amount: Int)
    case editAmountInCart(productID: Int, amount: Int)
    case deleteProductFromCart(productID: Int)
    case getProfileInfo(authorization:String)
    case setProfileInfo(authorization:String, firstName:String, lastName:String)
    case search(filterType: String, sortType: String, searchWord: String)

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
        case .signUp:
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
        case .search(let filterType, let sortType, let searchWord):
            return "api/product/search/\(filterType)/\(sortType)/"
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
        case .signUp(let username, let password, let user_type):
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
        case .search(let filterType, let sortType, let searchWord):
            params["searched"] = searchWord.lowercased()
        default:
            break
        }
        return params
    }
    // MARK: - Headers
    internal var headers: HTTPHeaders? {
        var headers = HTTPHeaders.init()
        switch self {
        case .authenticate:
            headers["Accept"] = "application/json"
        case .signUp:
            headers["Accept"] = "application/json"
        case .resetPasswordEmail:
            headers["Accept"] = "application/json"
        case .getCustomerLists(_, let isCustomerLoggedIn):
            if isCustomerLoggedIn {
                headers["Authorization"] = "Token " +  (UserDefaults.standard.value(forKey: K.token) as! String)
            }
        case .addList, .deleteList, .deleteProductFromList , .editList:
            headers["Authorization"] = "Token " +  (UserDefaults.standard.value(forKey: K.token) as! String)
        case .getCart, .addToCart, .editAmountInCart, .deleteProductFromCart:
            headers["Authorization"] = "Token " +  (UserDefaults.standard.value(forKey: K.token) as! String)
            //headers["Authorization"] = "Token " + "ce4b96c3f871f70954f5f41d1068fea3b8c92766"
        case .getProfileInfo(let authorization):
            headers["Authorization"] = "Token \(authorization)"
        case .setProfileInfo(let authorization,_,_):
            headers["Authorization"] = "Token \(authorization)"
        case .updatePassword:
             headers["Accept"] = "application/json"
        case .search(_, _, _):
            headers["Authorization"] = "Token " +  (UserDefaults.standard.value(forKey: K.token) as! String)
        
        }
        return headers
    }
    
    // MARK: - Methods
    internal var method: HTTPMethod {
        switch self {
        case .authenticate, .addList:
            return .post
        case .getCustomerLists:
            return .get
        case .deleteList, .deleteProductFromList:
            return .delete
        case .editList:
            return .put
        case .signUp:
            return .post
        case .resetPasswordEmail:
            return .post
        case .getCart:
            return .get
        case .addToCart:
            return .post
        case .editAmountInCart:
            return .put
        case .deleteProductFromCart:
            return .delete
        case .getProfileInfo:
            return .get
        case .setProfileInfo:
            return .put
        case .updatePassword:
            return .post
        case .search:
            return .post
        }
    }
}
