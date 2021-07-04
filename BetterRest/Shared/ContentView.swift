//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/6/22.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeupDate: Date = defaultWakeupDate();
    @State private var cupOfCoffee: Int = 1;
    @State private var desiredSleep: Double = 8;
    
    static func defaultWakeupDate() -> Date {
        var now = Calendar.current.dateComponents(in: .current, from: Date());
        now.day = now.day! + 1;
        now.hour = 8;
        now.minute = 0;
        return Calendar.current.date(from: now) ?? Date();
    }
    
    private var wakeInput: Double {
        var start = Calendar.current.dateComponents(in: .current, from: wakeupDate)
        start.hour = 0
        start.minute = 0
        let startDate = Calendar.current.date(from: start)!
        let diff = Calendar.current.dateComponents([.minute, .hour, .second], from: startDate, to: wakeupDate)
        return Double(diff.second! + diff.minute! * 60 + diff.hour! * 3600);
    }
    
    private var calculatedSleepTime: Date {
        let sleepModel: SleepModel = {
            do {
                let config = MLModelConfiguration()
                return try SleepModel(configuration: config)
            } catch {
                print(error)
                fatalError("cannot create SleepModel")
            }
        }()
        let input = SleepModelInput(wake: wakeInput, estimatedSleep: Double(desiredSleep), coffee: Double(cupOfCoffee))
        do {
            let output = try sleepModel.prediction(input: input)
            let sleepDate = wakeupDate - output.actualSleep
            return sleepDate
        } catch {
            return wakeupDate
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    VStack {
                        Text("When do you want to wake up?")
                        DatePicker("", selection: $wakeupDate)
                            .labelsHidden()
                    }
                }

                Section {
                    VStack {
                        Text("How many cups of coffee do you have drank?")
                        Stepper(value: $cupOfCoffee, in: 0...5) {
                            Text("\(cupOfCoffee) cups")
                        }
                    }
                }
                
                Section {
                    VStack {
                        Text("How many hours do you want to sleep?")
                        Stepper(value: $desiredSleep, in: 2...12, step: 0.25) {
                            Text("\(desiredSleep, specifier: "%g") hours")
                        }
                    }
                }
                
                Section {
                    Text("You should go to bed at \(calculatedSleepTime, style: .time) in \(calculatedSleepTime, style: .date)")
                }

            }
            .navigationTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
