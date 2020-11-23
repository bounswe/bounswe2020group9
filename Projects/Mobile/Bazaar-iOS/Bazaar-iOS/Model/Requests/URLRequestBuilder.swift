//
//  URLRequestBuilder.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.11.2020.
//

import Foundation
import Alamofire

protocol URLRequestBuilder: URLRequestConvertible {
    
    var mainURL: URL { get }
    var requestURL: URL { get }
    // MARK: - Path
    var path: String { get }
    
    // MARK: - Parameters
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get}
    
    // MARK: - Methods
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    var urlRequest: URLRequest { get }
}


extension URLRequestBuilder {
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var mainURL: URL  {
        return URL(string: "http://13.59.236.175:8000/")!
    }
    
    var requestURL: URL {
        return mainURL.appendingPathComponent(path)
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        return request
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var result = try encoding.encode(urlRequest, with: parameters)
        if let head = headers {
            for header in head {
                result.addValue(header.value, forHTTPHeaderField: header.name)
            }
        }
        return result
    }
}
