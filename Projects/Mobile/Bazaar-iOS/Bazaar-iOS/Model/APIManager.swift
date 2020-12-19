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
            AF.request(request).responseJSON {(response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:AuthData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData.token))
                        UserDefaults.standard.set(String(decodedData.user_id), forKey: K.userIdKey)
                        UserDefaults.standard.set(String(decodedData.token), forKey: K.token)
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func signUp(username:String, password:String, userType:String ,completionHandler: @escaping (Result<String ,Error>) -> Void) {
        do {
            let request = try ApiRouter.signUp(username: username, password: password, user_type: userType).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:SignUpData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success("\(decodedData.message)"))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func resetPasswordEmail(username:String,completionHandler: @escaping (Result<String ,Error>) -> Void)  {
        do {
            let request = try ApiRouter.resetPasswordEmail(username: username).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:ResetPassWordEmailData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success("\(decodedData.message)"))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
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
    
    func getCustomerLists(customer:String, isCustomerLoggedIn:Bool, completionHandler: @escaping (Result<[CustomerListData] , Error>) -> Void) {
        do {
            let request = try ApiRouter.getCustomerLists(customer: customer, isCustomerLoggedIn: isCustomerLoggedIn).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:[CustomerListData] = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func addList(name:String, customer:String, isPrivate:Bool, completionHandler: @escaping (Result<CustomerListData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.addList(name: name, customer: customer, isPrivate: isPrivate).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:CustomerListData = APIParse().parseJSON(safeData: safeData) {
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func deleteList(customer:String, id:String , completionHandler: @escaping (Result<String ,Error>) -> Void) {
        do {
            let request = try ApiRouter.deleteList(customer: customer, id: id).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if response.response?.statusCode == 204 {
                    completionHandler(.success("success"))
                }
                else if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:[String:String] = APIParse().parseJSON(safeData: safeData), decodedData.values.first != "not allowed to access"{
                        completionHandler(.success("success"))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func deleteProductFromList(customer:String, list_id:String, product_id:String , completionHandler: @escaping (Result<CustomerListData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.deleteProductFromList(customer: customer, list_id: list_id, product_id: product_id).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:CustomerListData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func editList(customer:String, list:String, newName:String , newIsPrivate:String, completionHandler: @escaping (Result<CustomerListData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.editList(customer: customer, list: list, newName: newName, newIsPrivate: newIsPrivate).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:CustomerListData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func getCart(user:String, completionHandler: @escaping (Result<Cart, Error>) -> Void) {
        do {
            let request = try ApiRouter.getCart(user: user).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode == 200) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData: Cart = APIParse().parseJSON(safeData: safeData) {
                        completionHandler(.success(decodedData))
                    } else {
                        completionHandler(.failure(MyError.runtimeError("err")))
                    }
                }
            }
        } catch let error {
            completionHandler(.failure(error))
        }
    }
    
    func addToCart(user: String, productID: Int, amount: Int, completionHandler: @escaping (Result<Cart, Error>) -> Void) {
        do {
            let request = try ApiRouter.addToCart(user: user, productID: productID, amount: amount).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode == 200) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData: Cart = APIParse().parseJSON(safeData: safeData) {
                        completionHandler(.success(decodedData))
                    } else {
                        completionHandler(.failure(MyError.runtimeError("err2")))
                    }
                }
            }
        } catch let error {
            completionHandler(.failure(error))
        }
    }
    
    func editAmountInCart(productID: Int, amount: Int, completionHandler: @escaping (Result<Cart, Error>) -> Void) {
        do {
            let request = try ApiRouter.editAmountInCart(productID: productID, amount: amount).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode == 200) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData: Cart = APIParse().parseJSON(safeData: safeData) {
                        completionHandler(.success(decodedData))
                    } else {
                        completionHandler(.failure(MyError.runtimeError("err2")))
                    }
                }
            }
        } catch let error {
            completionHandler(.failure(error))
        }
    }
    
    func deleteProductFromCart(productID: Int, completionHandler: @escaping (Result<Cart, Error>) -> Void) {
        do {
            let request = try ApiRouter.deleteProductFromCart(productID: productID).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode != nil) {
                    if response.response?.statusCode == 204 {
                        completionHandler(.failure(MyError.runtimeError("product already in cart")))
                    }
                    guard let safeData = response.data else {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData: Cart = APIParse().parseJSON(safeData: safeData) {
                        completionHandler(.success(decodedData))
                    } else {
                        completionHandler(.failure(MyError.runtimeError("err3")))
                    }
                }
            }
        } catch let error {
            completionHandler(.failure(error))
        }
    }
}
