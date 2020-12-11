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
        case .addList:
            headers["Authorization"] = "Token " +  (UserDefaults.standard.value(forKey: K.token) as! String)
        case .deleteList:
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
        case .deleteList:
            return .delete
        }
    }

}
