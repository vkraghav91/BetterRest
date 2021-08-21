//
//  ContentView.swift
//  BetterRest
//
//  Created by Varun Kumar Raghav on 19/08/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
//    @State private var alertMessage = ""
    private var suggestedBedTime: String {
        calculateBedtime()
    }

    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    
    
    var body: some View {
        NavigationView {
                Form{
                    Section(header:
                                Text("When do you want to wake up?").font(.headline)
                                    ){
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                            .frame(height: 150)
                    }
                    
                    Section(header:Text("Desired amount of sleep")
                                .font(.headline)){
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25){
                            Text("\(sleepAmount, specifier: "%g") hours")
                        }.foregroundColor(.black)
                    }
                    Section(header: Text("Daily coffee intake").font(.headline)){
                        
//                        Stepper(value: $coffeeAmount, in: 1...20, step: 1){
//                            if coffeeAmount == 1{
//                                Text("1 cup")
//                            }
//                            else{
//                                Text("\(coffeeAmount) cups")
//                            }
//                        }
                        
                        Picker( "", selection: $coffeeAmount){
                            ForEach(1 ..< 21){
                                if $0 == 1{
                                    Text("1 Cup").frame(width: 300)
                                }
                                else{
                                    Text("\($0) Cups").frame(width: 300)
                                }
                            }
                        }.foregroundColor(.black)
                        .frame(width: 300)
                        
                        //.pickerStyle(WheelPickerStyle())
                    }
                    Section(header: Text("Recommended Bed Time").font(.headline)){
                        Text(self.suggestedBedTime)
                            .font(.title)
                            .bold()
                            .foregroundColor(.blue)
                            .frame(width: 300)
                            
                            
                            
                    }
                
            }
//                .alert(isPresented: $showingAlert, content: {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            })
            .navigationBarTitle("BettterRest")
 //           .navigationBarItems(trailing: //takes a view
//                                    Button(action: calculateBedtime){
//                                        Text("Calculate Bedtime")
//                                    }
//            )
        }
    }
    func calculateBedtime()-> String {
        var alert = ""
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            // more code
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            alert = formatter.string(from: sleepTime)
//            alertMessage = formatter.string(from: sleepTime)
           // alertTitle = "Your ideal bedtime is .."
        } catch  {
            // Something went wrong here
           // alertTitle = "Error"
           // alertMessage = "Sorry, there was a problem calculating your bedtime."
            alert = "Sorry, there was a problem calculating your bedtime."
        }
       // showingAlert = true
        return alert
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
