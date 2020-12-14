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
    case getCustomerLists(customer: String, isCustomerLoggedIn: Bool)
    case addList(name: String, customer: String, isPrivate: Bool)
    case deleteList(customer: String, id: String)
    case deleteProductFromList(customer: String, list_id: String, product_id: String)
    case editList(customer:String, list: String, newName: String, newIsPrivate: String)
    // MARK: - Path
    internal var path: String {
        switch self {
        case .authenticate:
            return "api/user/login/"
        case .getCustomerLists(let customer, _):
            return "api/user/"+customer+"/lists/"
        case .addList(_, let customer, _):
            return "api/user/" + customer + "/lists/"
        case .deleteList(let customer, let id):
            return "api/user/" + customer + "/list/"+id+"/"
        case .deleteProductFromList(let customer, let list_id, _):
            return "api/user/" + customer + "/list/" + list_id + "/edit/"
        case .editList(let customer, let list, _,_):
            return "/api/user/" + customer + "/list/" + list + "/"
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
        default:
            break
        }
        return params
    }
    // MARK: - Headers
    internal var headers: HTTPHeaders? {
        var headers = HTTPHeaders.init()
        switch self {
        case .authenticate( _, _):
            headers["Accept"] = "application/json"
        case .getCustomerLists(_, let isCustomerLoggedIn):
            if isCustomerLoggedIn {
                headers["Authorization"] = "Token " +  (UserDefaults.standard.value(forKey: K.token) as! String)
            }
        case .addList, .deleteList, .deleteProductFromList , .editList:
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
        }
    }

}
