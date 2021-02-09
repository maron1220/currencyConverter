//
//  AddCurrecyView.swift
//  Currency-Converter
//
//  Created by 細川聖矢 on 2021/02/09.
//

import SwiftUI

struct AddCurrecyView: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        List {
                   ForEach(userData.allCurrencies) { currency in
                       return HStack {
                           
                               Text("\(currency.code) - \(currency.name)")
                           }
                           
                       }
                   }
                   }
    }
 


struct AddCurrecyView_Previews: PreviewProvider {
    static var previews: some View {
        AddCurrecyView()
    }
}
