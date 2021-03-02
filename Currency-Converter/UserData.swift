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
    Currency(name: "Japanese yen", rate: 1.0, code: "JPY"),
    Currency(name:"US doller",rate:1.0,symbol: "US",code: "USD"),
    Currency(name:"Canadian doller",rate:1.0,symbol: "CA",code: "CAD"),
    Currency(name:"Thai baht",rate: 1.0,symbol:"TH",code: "THB"),
    Currency(name:"Philippine peso", rate:1.0,symbol:"PH",code:"PHP"),
    Currency(name:"Czech koruna", rate: 1.0, symbol:"CZ",code:"CZK"),
    Currency(name:"Brazilian real", rate: 1.0, symbol: "BR",code:"BRL"),
    Currency(name:"Swiss franc", rate: 1.0,symbol: "CH",code:"CHF"),
    Currency(name:"Indian rupee",rate:1.0,symbol:"IN",code:"INR"),
    Currency(name:"Icelandic króna", rate: 1.0,symbol:"IS",code:"ISK"),
    Currency(name:"Croatian kuna", rate: 1.0,symbol:"HR",code:"HRK"),
    Currency(name:"Polish złoty", rate: 1.0,symbol:"PL",code:"PLN"),
    Currency(name:"Norwegian krone", rate: 1.0,symbol:"NO",code:"NOK"),
    Currency(name:"Chinese Renminbi", rate: 1.0,symbol:"CN",code:"CNY"),
    Currency(name:"Russian ruble", rate: 1.0,symbol:"RU",code:"RUB"),
    Currency(name:"Swedish krona", rate: 1.0,symbol:"SE",code:"SEK"),
    Currency(name:"Malaysian ringgit", rate: 1.0,symbol:"MY",code:"MYR"),
    Currency(name:"Singapore dollar", rate: 1.0,symbol:"SG",code:"SGD"),
    Currency(name:"Israeli new shekel", rate: 1.0,symbol:"IL",code:"ILS"),
    Currency(name:"Turkish lira", rate: 1.0,symbol:"TR",code:"TRY"),
    Currency(name:"Bulgarian lev", rate: 1.0,symbol:"BG",code:"BGN"),
    Currency(name:"New Zealand dollar", rate: 1.0,symbol:"NZ",code:"NZD"),
    Currency(name:"Hong Kong dollar", rate: 1.0,symbol:"HK",code:"HKD"),
    Currency(name:"Romanian leu", rate: 1.0,symbol:"RO",code:"RON"),
    Currency(name:"Euro", rate: 1.0,symbol:"EU",code:"EUR"),
    Currency(name:"Mexican peso", rate: 1.0,symbol:"MX",code:"MXN"),
    Currency(name:"Australian dollar", rate: 1.0,symbol:"AU",code:"AUD"),
    Currency(name:"Pound sterling", rate: 1.0,symbol:"GB",code:"GBP"),
    Currency(name:"South Korean won", rate: 1.0,symbol:"KR",code:"KRW"),
    Currency(name:"Indonesian rupiah", rate: 1.0,symbol:"ID",code:"IDR"),
    Currency(name:"Danish krone", rate: 1.0,symbol:"DK",code:"DKK"),
    Currency(name:"South African rand",rate:1.0,symbol:"ZA",code:"ZAR"),
    Currency(name:"Hungarian forint", rate: 1.0,symbol:"HU",code:"HUF")
]

@propertyWrapper
struct UserDefaultValue<Value:Codable> {
    var wrappedValue:Value
    let key:String
//    let defaultValue:Value
    
    var value:Value{
        get{
            let data = UserDefaults.standard.data(forKey: key)
            let value = data.flatMap{
                try? JSONDecoder().decode(Value.self, from: $0)
                        }//flatMap
            return value ?? wrappedValue
        }//get
        set{
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data,forKey: key)
        }//set
    }//value
}

final class UserData:ObservableObject{
    let didChange = PassthroughSubject<UserData,Never>()
    
    @UserDefaultValue(wrappedValue: defaultCurrencies, key:"allCurrencies")
    var allCurrencies:[Currency]{
        didSet{
            didChange.send(self)
        }//didset
    }//allCurencies
    
    @UserDefaultValue(wrappedValue: defaultCurrencies[0], key:"baseCurrencies")
    var baseCurrencies:Currency{
        didSet{
            didChange.send(self)
        }//didset
    }//baseCurencies
    
    @UserDefaultValue(wrappedValue: defaultCurrencies, key:"userCurrencies")
    var userCurrencies:[Currency]{
        didSet{
            didChange.send(self)
        }//didset
    }//userCurencies
}//final class
