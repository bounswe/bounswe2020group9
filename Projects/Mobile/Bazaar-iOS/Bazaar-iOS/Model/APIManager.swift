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
                        completionHandler(.failure(MyError.runtimeError("Error")))
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
    
    func signUpCustomer(firstName:String, lastName:String ,username:String, password:String, userType:String ,completionHandler: @escaping (Result<String ,Error>) -> Void) {
        do {
            let request = try ApiRouter.signUpCustomer(firstName:firstName, lastName: lastName ,username: username, password: password, user_type: userType).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
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
    
    func signUpVendor(firstName:String, lastName:String, username:String, password:String, user_type:String,addressName:String, address:String, country:String , city:String, postalCode:Int, latitude:Float, longitude:Float, companyName:String ,completionHandler: @escaping (Result<String ,Error>) -> Void) {
        do {
            let request = try ApiRouter.signUpVendor(firstName: firstName, lastName: lastName, username: username, password: password, user_type: user_type, addressName: addressName, address: address, country: country, city: city, postalCode: postalCode, latitude: latitude, longitude: longitude, companyName: companyName).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
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
    
    func googleSingIn(username:String, token:String, firstName:String, lastName:String ,completionHandler: @escaping (Result<Int ,Error>) -> Void) {
        do {
            let request = try ApiRouter.googleSignIn(userName: username, token: token, firstName: firstName, lastName: lastName).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:GoogleSignInData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData.id))
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
                        completionHandler(.failure(MyError.runtimeError("Error")))
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
    func updatePassword(userId:Int,currentPassword:String,newPassword:String,completionHandler: @escaping (Result<String ,Error>) -> Void)  {
        do {
            let request = try ApiRouter.updatePassword(userId:userId ,currentPassword: currentPassword, newPassword: newPassword).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:UpdatePasswordData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData.message))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func getProfileInfo(authorization:String,completionHandler: @escaping (Result<ProfileData ,Error>) -> Void)  {
        do {
            let request = try ApiRouter.getProfileInfo(authorization: authorization).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:ProfileData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func setProfileInfo(authorization:String,firstName:String,lastName:String,completionHandler: @escaping (Result<ProfileData ,Error>) -> Void)  {
        do {
            let request = try ApiRouter.setProfileInfo(authorization: authorization, firstName: firstName, lastName: lastName).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(response.error!))
                        return
                    }
                    if let decodedData:ProfileData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
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
        let callURL = "http://3.121.223.52:8000/api/product/"
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

    
    func getCustomerOrders( completionHandler: @escaping ([OrderData_Cust]?) -> Void) {
        do {
            let request = try ApiRouter.getCustomerOrders.asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        AllOrders.shared.jsonParseError = true
                        AllOrders.shared.dataFetched = false
                        completionHandler(nil)
                        return
                    }
                    if let decodedData:[OrderData_Cust] = APIParse().parseJSON(safeData: safeData){
                        AllOrders.shared.jsonParseError = false
                        AllOrders.shared.apiFetchError = false
                        AllOrders.shared.dataFetched = true
                        completionHandler(decodedData)
                    }else {
                        AllOrders.shared.jsonParseError = true
                        AllOrders.shared.dataFetched = false
                        completionHandler(nil)
                    }
                }
            }
        }catch let err {
            print(err)
            AllOrders.shared.jsonParseError = true
            AllOrders.shared.dataFetched = false
            completionHandler(nil)
        }
    }
    
    func getVendorOrders( completionHandler: @escaping ([VendorOrderData]?) -> Void) {
        do {
            let request = try ApiRouter.getVendorOrders.asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        AllOrders_vendor.shared.jsonParseError = true
                        AllOrders_vendor.shared.dataFetched = false
                        completionHandler(nil)
                        return
                    }
                    if let decodedData:[VendorOrderData] = APIParse().parseJSON(safeData: safeData){
                        AllOrders_vendor.shared.jsonParseError = false
                        AllOrders_vendor.shared.apiFetchError = false
                        AllOrders_vendor.shared.dataFetched = true
                        completionHandler(decodedData)
                    }else {
                        AllOrders_vendor.shared.jsonParseError = true
                        AllOrders_vendor.shared.dataFetched = false
                        completionHandler(nil)
                    }
                }
            }
        }catch let err {
            print(err)
            AllOrders_vendor.shared.jsonParseError = true
            AllOrders_vendor.shared.dataFetched = false
            completionHandler(nil)
        }
    }
    
    func deleteOrder(delivery_id:Int ,status:Int, completionHandler: @escaping (Result<String ,Error>) -> Void) {
        do {
            let request = try ApiRouter.deleteOrder(delivery_id: delivery_id, status:status).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if response.response?.statusCode == 204 {
                    completionHandler(.success("success"))
                }
                else if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:[String:String] = APIParse().parseJSON(safeData: safeData){
                        if (decodedData["message"]=="Updated Successfully"){
                            completionHandler(.success("success"))
                        }else{
                            print("Failed to parse returned message: " + decodedData["message"]!)
                            completionHandler(.failure(MyError.runtimeError("Error")))
                        }
                        
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func getCustomerLists(userId:Int, isCustomerLoggedIn:Bool, completionHandler: @escaping (Result<[CustomerListData] , Error>) -> Void) {
        do {
            let request = try ApiRouter.getCustomerLists(userId: userId, isCustomerLoggedIn: isCustomerLoggedIn).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
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
    
    
    func addList(name:String, userId:Int, isPrivate:Bool, completionHandler: @escaping (Result<CustomerListData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.addList(name: name, userId: userId, isPrivate: isPrivate).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
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
    
    func deleteList(userId:Int, id:String , completionHandler: @escaping (Result<String ,Error>) -> Void) {
        do {
            let request = try ApiRouter.deleteList(userId: userId, id: id).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if response.response?.statusCode == 204 {
                    completionHandler(.success("success"))
                }
                else if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
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
    
    func deleteProductFromList(userId:Int, list_id:String, product_id:String , completionHandler: @escaping (Result<CustomerListData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.deleteProductFromList(userId: userId, list_id: list_id, product_id: product_id).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
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
    
    func editList(userId:Int, list:String, newName:String , newIsPrivate:String, completionHandler: @escaping (Result<CustomerListData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.editList(userId: userId, list: list, newName: newName, newIsPrivate: newIsPrivate).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
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
    
    func addToList(userId:Int, list_id:Int, product_id:Int, completionHandler: @escaping (Result<CustomerListData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.addToList(userId: userId, list_id: list_id, product_id: product_id).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
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
    
    func getCart(user:Int, completionHandler: @escaping (Result<[CartProduct], Error>) -> Void) {
        do {
            let request = try ApiRouter.getCart(user: user).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode == 200) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData: [CartProduct] = APIParse().parseJSON(safeData: safeData) {
                        completionHandler(.success(decodedData))
                    } else {
                        completionHandler(.failure(MyError.runtimeError("err")))
                    }
                }
            }
        } catch let error {
            print(error)
            completionHandler(.failure(error))
        }
    }
    
    func addToCart(user: Int, productID: Int, amount: Int, completionHandler: @escaping (Result<[CartProduct], Error>) -> Void) {
        do {
            let request = try ApiRouter.addToCart(user: user, productID: productID, amount: amount).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode == 200) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData: [CartProduct] = APIParse().parseJSON(safeData: safeData) {
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
    
    func editAmountInCart(productID: Int, amount: Int, completionHandler: @escaping (Result<[CartProduct], Error>) -> Void) {
        do {
            let request = try ApiRouter.editAmountInCart(productID: productID, amount: amount).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode == 200) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData: [CartProduct] = APIParse().parseJSON(safeData: safeData) {
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
    
    func deleteProductFromCart(productID: Int, completionHandler: @escaping (Result<[CartProduct], Error>) -> Void) {
        do {
            let request = try ApiRouter.deleteProductFromCart(productID: productID).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode != nil) {
                    if response.response?.statusCode == 204 {
                        completionHandler(.failure(MyError.runtimeError("product already in cart")))
                    }
                    guard let safeData = response.data else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData: [CartProduct] = APIParse().parseJSON(safeData: safeData) {
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
    
    func getComments(productID: Int, completionHandler: @escaping (Result<[CommentData], Error>) -> Void) {
        do {
            let request = try ApiRouter.getComments(product_id: productID).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode != nil) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData: [CommentData] = APIParse().parseJSON(safeData: safeData) {
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
    func search(filterType: String, sortType: String, searchWord: String, completionHandler: @escaping (Result<SearchProductList, Error>) -> Void) {
        do {
            let request = try ApiRouter.search(filterType: filterType, sortType: sortType, searchWord: searchWord).asURLRequest()
            AF.request(request).responseJSON { response in
                print(response)
                
                if (response.response?.statusCode != nil) {
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error-searchapicall-response-1")))
                        return
                    }
                    if let decodedData:SearchProductList = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Error-searchapicall-decode-2")))
                    }
                }
                
            }
        } catch let error {
            completionHandler(.failure(error))
        }
    }
    

    func getUsersComment(productID: Int, userID: Int, completionHandler: @escaping (Result<CommentData, Error>) -> Void) {
        do {
            let request = try ApiRouter.getUsersComment(product_id: productID, user_id: userID).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode != nil) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData: [CommentData] = APIParse().parseJSON(safeData: safeData) {
                        if decodedData.isEmpty {
                            completionHandler(.failure(MyError.runtimeError("Error")))
                        } else {
                            completionHandler(.success(decodedData[0]))
                        }
                    } else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                    }
                }
            }
        } catch let error {
            completionHandler(.failure(error))
        }
    }
    
    func getAllVendors(str:String, completionHandler: @escaping (Result<[VendorData], Error>) -> Void) {
        do {
            let request = try ApiRouter.getAllVendors(str: str).asURLRequest()
            AF.request(request).responseJSON { response in
                if (response.response?.statusCode != nil) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData: [VendorData] = APIParse().parseJSON(safeData: safeData) {
                        if decodedData.isEmpty {
                            completionHandler(.failure(MyError.runtimeError("Error")))
                        } else {
                            completionHandler(.success(decodedData))
                        }
                    } else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                    }
                }
            }
        } catch let error {
            completionHandler(.failure(error))
        }
    }
    
    func getNotifications( completionHandler: @escaping (NotificationsData?) -> Void) {
        do {
            let request = try ApiRouter.getNotifications.asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        AllNotifications.shared.jsonParseError = true
                        AllNotifications.shared.dataFetched = false
                        completionHandler(nil)
                        return
                    }
                    if let decodedData:NotificationsData = APIParse().parseJSON(safeData: safeData){
                        AllNotifications.shared.jsonParseError = false
                        AllNotifications.shared.apiFetchError = false
                        AllNotifications.shared.dataFetched = true
                        completionHandler(decodedData)
                    }else {
                        AllNotifications.shared.jsonParseError = true
                        AllNotifications.shared.dataFetched = false
                        completionHandler(nil)
                    }
                }
            }
        }catch let err {
            print(err)
            AllNotifications.shared.jsonParseError = true
            AllNotifications.shared.dataFetched = false
            completionHandler(nil)
        }
    }
    
    func addNewCreditCard(owner:Int, nameOnCard:String, cardNumber:String, month:String, year:String, cvv:String, cardName:String,completionHandler: @escaping (Result<CreditCardData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.addNewCreditCard(owner: owner, nameOnCard: nameOnCard, cardNumber: cardNumber, month: month, year: year, cvv: cvv, cardName: cardName).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:CreditCardData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func getCreditCards(completionHandler: @escaping (Result<[CreditCardData] ,Error>) -> Void) {
        do {
            let request = try ApiRouter.getCreditCards.asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:[CreditCardData] = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func removeCreditCard(id:Int, owner:Int,completionHandler: @escaping (Result<String ,Error>) -> Void) {
        do {
            let request = try ApiRouter.removeCreditCard(id: id, owner: owner).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:removeCreditCardData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData.message))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func getVendorsProducts(vendorId:Int, completionHandler: @escaping (Result<[ProductData] ,Error>) -> Void) {
        do {
            let request = try ApiRouter.getVendorsProducts(vendorId: vendorId).asURLRequest()
            AF.request(request).responseJSON { response in
                print(response)
                if (response.response?.statusCode != nil ) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:[ProductData] = APIParse().parseJSON(safeData: safeData) {
                        completionHandler(.success(decodedData))
                    } else {
                      completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
             }
          } catch let err {
            completionHandler(.failure(err))
          }
      }

    func addNewAddressForCustomer(addressName:String , fullAddress:String, country:String, city:String, postalCode:Int,user:Int, completionHandler: @escaping (Result<AddressData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.addNewAddressForCustomer(addressName: addressName, fullAddress: fullAddress, country: country, city: city, postalCode: postalCode, user: user).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:AddressData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        } catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func vendorAddProduct(title:String, brand:String, price:Double, stock:Int, description:String, image:String, categoryID: Int, completionHandler: @escaping (Result<ProductData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.vendorAddProduct(title: title, brand: brand, price: price, stock: stock, description: description, image: image, categoryID: categoryID).asURLRequest()
            AF.request(request).responseJSON { response in
                print(response)
                if (response.response?.statusCode != nil ) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:ProductData = APIParse().parseJSON(safeData: safeData) {
                        completionHandler(.success(decodedData))
                    } else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
          }catch let err {
            completionHandler(.failure(err))
        }
    }
    func getCustomerAddresses(completionHandler: @escaping (Result<[AddressData] ,Error>) -> Void) {
        do {
            let request = try ApiRouter.getCustomerAddresses.asURLRequest()
            AF.request(request).responseJSON { (response) in
                print(response)
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:[AddressData] = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    

    func vendorEditProduct(prodID:Int, title:String, brand:String, price:Double, stock:Int, description:String, image:String, categoryID: Int, completionHandler: @escaping (Result<ProductData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.vendorEditProduct(prodId:prodID, title: title, brand: brand, price: price, stock: stock, description: description, image: image, categoryID: categoryID).asURLRequest()
            AF.request(request).responseJSON { response in
                print("api:", response)

                if (response.response?.statusCode != nil ) {
                    guard let safeData = response.data else {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:ProductData = APIParse().parseJSON(safeData: safeData) {
                        completionHandler(.success(decodedData))
                    } else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    func removeCustomerAddress(addressId:Int ,completionHandler: @escaping (Result<[AddressData] ,Error>) -> Void) {
        do {
            let request = try ApiRouter.removeCustomerAddress(addressId: addressId).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:[AddressData] = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func updateCustomerAddress(addressId:Int,addressName:String , fullAddress:String, country:String, city:String, postalCode:Int,user:Int, completionHandler: @escaping (Result<AddressData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.updateCustomerAddress(addressId: addressId, addressName: addressName, fullAddress: fullAddress, country: country, city: city, postalCode: postalCode, user: user).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:AddressData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }
    
    func placeOrder(userId:Int, products:[Int:Int], add_id:Int, completionHandler: @escaping (Result<[OrderData] ,Error>) -> Void) {
        do {
            let request = try ApiRouter.placeOrder(userId: userId, products: products, add_id: add_id).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:[OrderData] = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }

    func deleteAccount(token: String) {
        do {
            let request = try ApiRouter.deleteAccount(token: token).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                }
            }
        }catch {
           //
        }
    }
    
    func getConversations(completionHandler: @escaping (Result<AllConversationsData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.getConversations.asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:AllConversationsData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }

    func getMessages(id:Int, completionHandler: @escaping (Result<[MessageData] ,Error>) -> Void) {
        do {
            let request = try ApiRouter.getMessages(id: id).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:[MessageData] = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }

    func getConversationsWithMessages( completionHandler: @escaping (Result<AllConversationsData ,Error>) -> Void) {
        do {
            let request = try ApiRouter.getConversationsWithMessages.asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    guard let safeData = response.data else  {
                        completionHandler(.failure(MyError.runtimeError("Error")))
                        return
                    }
                    if let decodedData:AllConversationsData = APIParse().parseJSON(safeData: safeData){
                        completionHandler(.success(decodedData))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        }catch let err {
            completionHandler(.failure(err))
        }
    }

    func sendMessage(receiver:String, body:String, completionHandler: @escaping (Result<String ,Error>) -> Void) {
        do {
            let request = try ApiRouter.sendMessage(receiver_username: receiver, body: body).asURLRequest()
            AF.request(request).responseJSON { (response) in
                if (response.response?.statusCode != nil){
                    if response.response?.statusCode == 201 {
                        completionHandler(.success("Success"))
                    }else {
                        completionHandler(.failure(MyError.runtimeError("Failed to parse json ")))
                    }
                }
            }
        } catch let err {
            completionHandler(.failure(err))
        }
    }
}


