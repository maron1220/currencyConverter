//
//  UserData.swift
//  Currency-Converter
//
//  Created by 細川聖矢 on 2021/02/09.
//

import Foundation
import SwiftUI
import Combine

private let defaultCurrencies:[Currency] = [
    Currency(name:"US doller",rate:1.0,symbol: "US",code: "USD"),
    Currency(name:"Canadian doller",rate:1.0,symbol: "CA",code: "CAD")
    
]

@propertyWrapper
struct UserDefaultValue<Value:Codable> {
    var wrappedValue:Value
    let key:String
    let defaultValue:Value
    
    var value:Value{
        get{
            let data = UserDefaults.standard.data(forKey: key)
            let value = data.flatMap{
                try? JSONDecoder().decode(Value.self, from: $0)
                        }//flatMap
            return value ?? defaultValue
        }//get
        set{
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data,forKey: key)
        }//set
    }//value
}

final class UserData:ObservableObject{
    let didChange = PassthroughSubject<UserData,Never>()
    
    @UserDefaultValue(wrappedValue: defaultCurrencies, key:"allCurrencies",defaultValue:defaultCurrencies)
    var allCurrencies:[Currency]{
        didSet{
            didChange.send(self)
        }//didset
    }//allCurencies
    
    @UserDefaultValue(wrappedValue: defaultCurrencies[0], key:"baseCurrencies",defaultValue:defaultCurrencies[0])
    var baseCurrencies:Currency{
        didSet{
            didChange.send(self)
        }//didset
    }//baseCurencies
    
    @UserDefaultValue(wrappedValue: defaultCurrencies, key:"userCurrencies",defaultValue:defaultCurrencies)
    var userCurrencies:[Currency]{
        didSet{
            didChange.send(self)
        }//didset
    }//userCurencies
}//final class
