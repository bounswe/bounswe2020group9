//
//  StringHelper.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 21.11.2020.
//

import Foundation

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isName: Bool {
        guard self.count > 0, self.count < 18 else { return false }
        
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: self)
    }
    
    var formatDate: String {
        let str = self.prefix(19)+"Z"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd.MM.yyyy HH:mm"
        let date: Date? = dateFormatterGet.date(from: String(str))
        return dateFormatterPrint.string(from: date!);
    }
}
