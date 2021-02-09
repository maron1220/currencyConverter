//
//  CurrentryItemView.swift
//  Currency-Converter
//
//  Created by 細川聖矢 on 2021/02/09.
//

import SwiftUI

struct CurrentryItemView: View {
    @EnvironmentObject var userData:UserData
    let currency:Currency
    let baseAmount:Double
//    @Binding var isEdting:Bool
    
    var body: some View {
        let currency = self.currency
        let converstionRate = String(format:"%.4f",currency.rate/userData.baseCurrencies.rate)
        let totalAmount = String(format: "%.3f", baseAmount*(userData.baseCurrencies.rate/currency.rate))
        
//        HStack{
//            if self.isEdting{
//                //delete mode
//                HStack(alignment: .center){
//                    Image(systemName: "minus.circle")
//                        .foregroundColor(.red)
//                        .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/){
//                            
//                        }
//                }//HStack
//            }//if
            
//        }//HStack
        HStack{
            Text(currency.flag).font(.largeTitle)
            VStack(alignment: .leading){
                Text(currency.code).font(.headline)
                Text(currency.name).font(.footnote).foregroundColor(.gray)
            }//VStack
            Spacer()
            VStack(alignment: .leading){
                Text("\(totalAmount)")
                Text("1\(currency.code) = \(converstionRate)\(userData.baseCurrencies.code)").foregroundColor(.gray)
            }//VStack
        }//HStack
    }
}

struct CurrentryItemView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentryItemView(currency: Currency(name:"US doller",rate:1.0,symbol: "US",code: "USD"), baseAmount: 1.0)
    }
}
