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
    case signUp(username:String, password:String, user_type:String)
    // MARK: - Path
    internal var path: String {
        switch self {
        case .authenticate:
            return "api/user/login/"
        case .signUp:
            return "api/user/signup/"
        }
    }

    // MARK: - Parameters
    internal var parameters: Parameters? {
        var params = Parameters.init()
        switch self {
        case .authenticate(let username, let password):
            params["username"] = username
            params["password"] = password
        case .signUp(let username, let password, let user_type):
            params["username"] = username
            params["password"] = password
            params["user_type"] = user_type
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
        }
        return headers
    }
    
    // MARK: - Methods
    internal var method: HTTPMethod {
        switch self {
        case .authenticate:
            return .post
        case .signUp:
            return .post
        }
    }

}
