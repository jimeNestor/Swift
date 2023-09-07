//
//  ContentView.swift
//  UnitConversion
//
//  Created by Nestor Jimenez on 8/8/23.
//
/*
 
 This app handles unit conversions: users will select an input unit and an output unit
 - they will enter a value and see the output of the conversion
 
  Temperature conversion:
 */
import SwiftUI

struct ContentView: View {
    @State private var temperatureInput = 0.0
    @State private var temperatureOutput = 0.0
    @State private var selectedTemperatureInput = "C°"
    @State private var selectedTemperatureOutput = ""
    @FocusState private var inputTempFocused :Bool
    let temperatureUnits = ["C°", "F°", "K°"]
    
    var temperatureConversion : Double {
        var temperatureToConvert = temperatureInput
        
        if selectedTemperatureInput == "K°" {
            if selectedTemperatureOutput == "F°" {
                temperatureToConvert = (temperatureInput - 273.15) * 9 / 5 + 32
            } else if selectedTemperatureOutput == "C°" {
                temperatureToConvert = temperatureInput - 273.15
            } else {
                return temperatureInput
            }
        }
        
        if selectedTemperatureInput == "F°" {
            if selectedTemperatureOutput == "K°" {
                temperatureToConvert = (temperatureInput - 32) * (5 / 9) + 273.15
            } else if selectedTemperatureOutput == "C°" {
                temperatureToConvert = (temperatureInput -  32) * (5 / 9)
            } else {
                return temperatureInput
            }
        }
        
        if selectedTemperatureInput == "C°" {
            if selectedTemperatureOutput == "F°" {
                temperatureToConvert = temperatureInput * 9 / 5 + 32
            } else if selectedTemperatureOutput == "K°" {
                temperatureToConvert = temperatureInput + 273.15
            } else {
                return temperatureInput
            }
        }
        return temperatureToConvert
    }
    
    
    var body: some View {
        
        NavigationView {
            Form{
                Section {
                    TextField("Input Temperature to Convert: ", value: $temperatureInput, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputTempFocused)
                    
                    Picker("Select Unit of Input: ", selection: $selectedTemperatureInput) {
                        ForEach(temperatureUnits, id: \.self){
                            Text($0)
                        }
                    } .pickerStyle(.segmented)
                } header: {
                    Text("Temperature to convert:")
                }
                
                
                
                Section {
                    Text(temperatureConversion, format: .number)
                        
                    Picker("Select Unit of OutPut", selection: $selectedTemperatureOutput) {
                        ForEach(temperatureUnits, id: \.self){
                            Text($0)
                        }
                    } .pickerStyle(.segmented)
                    
                } header: {
                    Text("Converted Temperature:")
                }
            } .navigationTitle("Temperature Converter")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Done") {
                            inputTempFocused = false
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
