//
//  ContentView.swift
//  WeSplit
//
//  Created by Nestor Jimenez on 8/3/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = 0.0
    @State private var partySize = 0
    @State private var tipPercentage = 0

    @FocusState private var amountIsFocus:Bool
    let tipOptions = [10,15,20,25]

    
    /*
     totalPerPerson - computed property that calculates our total per person by using our variables that we provided and the selection and input by user
     */
    
    var totalPerPerson : Double {
        let size = Double(partySize + 2) // we need to add 2 bc the ForEach is off by 2
        let tip = Double(tipPercentage) //Converting our tip to double since we will use it in our calculation
        
        let tipAdded = checkAmount / 100 * tip //getting the tip amount to add with the tip percentage selected
        let grandTotal = checkAmount + tipAdded
        
        let total = grandTotal / size
        return total
    }
    
    
    
    
    var grandTotal : Double {
       let tipAmount = checkAmount / 100 *  Double(tipPercentage)
      let totalAmount = checkAmount + tipAmount
        
        return totalAmount
    }
    
    
    
    
    /*
     body is the only thing that View requires us to have as part of the protocol
     */
    
    var body: some View {
        
        NavigationView() {
            Form {
                
                /*
                 We use a TextField to display what we want the user to input
                 - it uses two-way-binding for the checkAmount so we can read it and update it
                 - we also change the type of keyboard so it can provide a decimalPad instead of the default alphabetical keyboard
                 */
                TextField("Check Amount", value: $checkAmount, format: .currency(code: "USD") )
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocus)
                
                Picker("Party Size: ", selection: $partySize) {
                    ForEach(2..<100){
                        Text($0, format: .number)
                    }
                }
                    
                    /*
                     This is the section that displays the percentage options
                     - we use a Picker to provide a dropdown selection that will allow us to hold the selected tip percentage.
                     - we use a ForEach to display each option available in the array as a view
                     - we use $0 to display the values in a percentage format
                     */
                    Section {
                    
                        Picker("Tip Percentage ", selection: $tipPercentage) {
                            ForEach(0..<101){
                                Text($0, format: .percent)
                            }
                            
                        }.pickerStyle(.navigationLink)
                    } header: {
                        Text("How much tip would you like to leave?")
                    }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: "USD"))
                } header: {
                    Text("Amount Per Person:")
                }
                
                Section {
                    Text(grandTotal, format: .currency(code: "USD"))
                      //  .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundColor(tipPercentage == 0 ? .red : .black)
                    //above it changes the text color to red if we left 0 for tip or keeps it the same if we left it as is.

                }
                
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                  //  Spacer() - when i use the spacer here, the done button is out of view when it should only be pushed to the right!
                    
                    Button("Done") {
                        amountIsFocus = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
