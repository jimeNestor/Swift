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
import CoreML
import SwiftUI


struct ContentView: View {
    
    /*
     The computed property is static because if we set wakeUp to the defaultWakeTime, we are attempting to access one property from another.
     - We need to make it static because it belongs to the ContentView Struct itself. rather than a single instance of the struct
     
     - this computed property is created so all our users have a set time.
     */
    static var defaultWakeTime: Date {
        var component = DateComponents()
        component.hour = 7
        component.minute = 0
        return Calendar.current.date(from: component) ?? Date.now
    }
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1.0
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    
    var body: some View {
        NavigationStack {
         
            /*
             Form provides us with a clear segmented table
             
             */
            Form {
                
               
                VStack(alignment: .leading, spacing: 0) {
                    Text("What Time Would you like to wake up?")
                        .font(.headline)
                    
                    DatePicker("Pick Wake Up Time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0){
                    Text("Desired Amount Of Sleep: ")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours of sleep", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("How Many cups of ☕️?")
                        .font(.headline)
                    Stepper(coffeeAmount == 1 ? "☕️:  1":"☕️'s: \(coffeeAmount.formatted())", value: $coffeeAmount, in: 1...11)
                }
                
                
        
                            .alert(alertTitle,isPresented: $showingAlert) {
                                Button("Ok") {}
                            } message: {
                                Text(alertMessage)
                            }
                            .navigationTitle("BetterRest")
                           .navigationBarTitleDisplayMode(.inline)
                           .toolbar {
                               Button("Calculate", action: calculateBedTime)
                                   .buttonStyle(.bordered)
                                   .foregroundColor(.white)
                                   .background(.blue)
                                   .clipShape(Capsule())
                    }
                    .padding()
                
            
           
            }
        }
    }
    
    
    func calculateBedTime() {
        
        //Craeting an instance of the SleepCalculator class
        /*
         we use the dp/catch blocks because openML can throw errors
         1. when loading
         2. when we ask for predictions
         */
        do {
            let config = MLModelConfiguration() //this is here in the case we need to enable certain options
            let model = try SleepCalculator(configuration: config) //this reads in all our data and will output a prediction
            //using dateComponents with the current locale to take hours and minutes
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            //feed the ML model:
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            //subtracting the time they want to wake up with the amount of actual sleep
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        showingAlert = true
        
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
