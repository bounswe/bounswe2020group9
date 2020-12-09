//
//  APIManager.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.11.2020.
//

import UIKit
import Alamofire

struct APIManager {
    let dateFormatter = DateFormatter()
    
    enum MyError: Error {
        case runtimeError(String)
    }
    
    func authenticate(username:String,password:String,completionHandler: @escaping (Result<String ,Error>) -> Void) {
        do {
            let request = try ApiRouter.authenticate(username: username, password: password).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:AuthData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData.token))
                        UserDefaults.standard.setValue(String(decodedData.user_id), forKey: K.user_id)
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    
    func getAllProducts(completionHandler: @escaping ([ProductData]?) -> Void) {
        let callURL = "http://13.59.236.175:8000/api/product/"
        if let url = URL(string: callURL){
            AF.request(url).responseJSON(completionHandler: {
                response in
                if response.data != nil {
                    do {
                        let allProducts = try JSONDecoder().decode([ProductData].self, from: response.data!)
                        AllProducts.shared.jsonParseError = false
                        AllProducts.shared.apiFetchError = false
                        AllProducts.shared.dataFetched = true
                        completionHandler(allProducts)
                    } catch {
                        print("error while decoding JSON for all products")
                        AllProducts.shared.jsonParseError = true
                        AllProducts.shared.dataFetched = false
                        completionHandler(nil)
                    }
                } else {
                    print("error while decoding JSON for all products")
                    AllProducts.shared.apiFetchError = true
                    AllProducts.shared.dataFetched = false
                    completionHandler(nil)
                }
                
            })
        } else {
            print("invalid url for getting all products")
            AllProducts.shared.apiFetchError = true
            AllProducts.shared.dataFetched = false
            completionHandler(nil)
        }
            
    }
    
    func getCustomerLists(completionHandler: @escaping ([CustomerListData]?) -> Void) {
        if let user_id =  UserDefaults.standard.value(forKey: K.user_id) as? String {
            let callURL = "http://13.59.236.175:8000/api/user/" + user_id + "/lists"
            if let url = URL(string: callURL){
                AF.request(url).responseJSON(completionHandler: {
                    response in
                    if response.data != nil {
                        do {
                            let lists = try JSONDecoder().decode([CustomerListData].self, from: response.data!)
                            CustomerLists.shared.jsonParseError = false
                            CustomerLists.shared.apiFetchError = false
                            CustomerLists.shared.dataFetched = true
                            completionHandler(lists)
                        } catch {
                            print("error while decoding JSON for all lists")
                            CustomerLists.shared.jsonParseError = true
                            CustomerLists.shared.dataFetched = false
                            completionHandler(nil)
                        }
                    } else {
                        print("error while decoding JSON for all lists")
                        CustomerLists.shared.apiFetchError = true
                        CustomerLists.shared.dataFetched = false
                        completionHandler(nil)
                    }
                    
                })
            } else {
                print("invalid url for getting all lists")
                CustomerLists.shared.apiFetchError = true
                CustomerLists.shared.dataFetched = false
                completionHandler(nil)
            }
        }else {
            print("invalid user")
            return
        }
    }
}
