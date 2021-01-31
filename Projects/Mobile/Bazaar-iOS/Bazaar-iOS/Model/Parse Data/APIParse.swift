//
//  APIParse.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.11.2020.
//

import Foundation
import Alamofire

struct APIParse: Codable {

    func parseJSON<T:Codable>(safeData:Data)-> T?  {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: safeData)
        } catch let err{
           print(err)
        }
        return nil
    }
}
