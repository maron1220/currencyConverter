//
//  ContentView.swift
//  Currency-Converter
//
//  Created by 細川聖矢 on 2021/02/09.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData:UserData
    @State var baseAmount:String = "1.0"
    @State var isEditing:Bool = false
    @State var lastUpdated:String = ""

    var body: some View {
        let inset = EdgeInsets(top: -8, leading: -20, bottom: -7, trailing: 5)
        let doubleValue:Double = Double(self.$baseAmount.wrappedValue) ?? 1.0
        
        ZStack(alignment: .bottomTrailing){
            VStack{
                Text("From").fontWeight(.bold).foregroundColor(.gray)
                HStack{
                    Text("\(userData.baseCurrencies.flag)").padding(5)
                    VStack(alignment: .leading){
                        Text(userData.baseCurrencies.code).foregroundColor(.white)
                        Text(userData.baseCurrencies.name).foregroundColor(.white)
                    }//VSTack
                    
                    Spacer()
                    TextField("1.0",text:$baseAmount).foregroundColor(.white)
                        .keyboardType(.decimalPad)
                        .frame(width:UIScreen.main.bounds.width/2)
                        .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(red: 0.7, green: 0.7, blue: 0.7), lineWidth: 1 / UIScreen.main.scale)
                            )//overlay
                            .padding(inset)
                            
                        )
                    Spacer()
                
                }//HStack
                .background(Color.blue)
                .cornerRadius(5)
                Text("To").bold().foregroundColor(.gray)
                
                NavigationView{
                    
                List{
                    ForEach(userData.userCurrencies){ currency in
                        //CurrencyItemを入れる
                        CurrentryItemView(currency: currency, baseAmount: doubleValue)
                            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                self.userData.baseCurrencies = currency
                            })//onTapGesture
                    }//ForeEach
//                    .onDelete(perform:delete)
                }//List
                .navigationBarTitle("Currenceis",displayMode: .inline)
                    
                }//NavigationView
                .onAppear(perform: {
                    //loadcurrencyをする
                })
                VStack{
                    NavigationLink(destination: AddCurrecyView().environmentObject(self.userData)){
                        Image(systemName: "i.circle").font(.system(size: 40, weight: .medium)).foregroundColor(Color(.systemOrange))
                    }//NavigationLink
                    .frame(width: 46, height: 46, alignment: .center)
                Text("Last updated:\(self.lastUpdated)").foregroundColor(.gray).bold()
                }//VStack
            }//VStack
            .onTapGesture{
                UIApplication.shared.closeKeyboard()
            }
        }//ZStack
    }
    
    func delete(at offsets:IndexSet){
        userData.userCurrencies.remove(atOffsets: offsets)
    }
}

private func loadCurrencies(){
    
}//loadCurrencies

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
