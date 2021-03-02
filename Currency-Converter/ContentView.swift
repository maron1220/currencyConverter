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
                    VStack(alignment: .center){
                        Text(userData.baseCurrencies.code).foregroundColor(.white)
                        Text(userData.baseCurrencies.name).foregroundColor(.white)
                    }//VSTack
                    
                    Spacer()
                    TextField("1.0",text:$baseAmount).foregroundColor(.white)
                        .multilineTextAlignment(.center)
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
//                            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
//                                self.userData.baseCurrencies = currency
//                            })//onTapGesture
                    }//ForeEach
//                    .onDelete(perform:delete)
                }//List
                .onAppear(perform:loadCurrencies)
                .navigationBarTitle("外貨レート",displayMode: .inline)
                    
                }//NavigationView
            
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
    
    private func loadCurrencies(){
        let url = URL(string: "https://api.exchangeratesapi.io/latest?base=JPY")!
        
        let task = URLSession.shared.dataTask(with: url , completionHandler: { data, _, _ in
            if let data = data {
                if let decoded:CurrencyList = self.decodeData(CurrencyList.self,data){
                    self.lastUpdated = decoded.date
                    
                    var newCurrencies = [Currency]()
                    for key in decoded.rates.keys{
                    var newCurrency = Currency(name: supportedCurrencies[key]?[0] ?? "Unknown",
                                               rate: 1.0/(decoded.rates[key] ?? 1.0), symbol: supportedCurrencies[key]?[1] ?? "",code: key)
                        newCurrencies.append(newCurrency)
                }//for key in decoded.rates.keys
                    
                    DispatchQueue.main.async {
                        self.userData.allCurrencies = newCurrencies
                        
                        if let base = self.userData.allCurrencies.filter({
                            $0.symbol == self.userData.baseCurrencies.symbol
                        })//filter
                        .first{
                            self.userData.baseCurrencies = base
                        }//first
                        
                        var tempNewUserCurrency = [Currency]()
                        let userCurrencies = self.userData.userCurrencies.map{$0.code}
                        for c in self.userData.allCurrencies{
                            if userCurrencies.contains(c.code){
                                tempNewUserCurrency.append(c)
                            }//if
                        }//for c in self.userData.allCurrencies
                        
                        self.userData.userCurrencies = tempNewUserCurrency
                    }//Dispatch
                    
                }//if let decoded:CurrencyList
            }//data
        }//completionHandler
        )//URLSession.shared.dataTask
        task.resume()
    }//loadCurrencies
    
    func delete(at offsets:IndexSet){
        userData.userCurrencies.remove(atOffsets: offsets)
    }
    
    
}

extension ContentView
{
    private func decodeData<T>(_ decodeObject:T.Type,_ data:Data) -> T? where T:Codable
    {
        let decoder = JSONDecoder()
        do
        {
            print("success")
            return try decoder.decode(decodeObject.self, from: data)
            
        }//do
        catch let jsonErr
        {
            print("Error decoding Json",jsonErr)
            return nil
        }//catch
    }//decodeData
}//extension

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserData())
    }
}
