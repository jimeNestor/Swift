//
//  ContentView.swift
//  BetterRest
// App to help coffee drinkers get a good nights sleep by asking 3 questions
// When do they want to wake up?
// How many hours of sleep do they want?
// How many cups of coffee do they drink per day?
//
// We will be using Core ML: to get a result telling us when they ought to be in bed
// we will use the technique: regression analysis
//
//
//
//
//  Created by Nestor Jimenez on 9/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    
    var body: some View {
        VStack {
            Stepper("\(sleepAmount.formatted()) hours of sleep", value: $sleepAmount, in: 4...12, step: 0.25)
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
