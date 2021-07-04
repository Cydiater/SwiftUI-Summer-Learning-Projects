//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/6/17.
//

import SwiftUI

struct ContentView: View {
    @State private var originAmountText = ""
    @State private var numberOfIndividulIndex: Int = 1
    @State private var tipPercentIndex: Int = 0
    
    private let tipPercents: [Int] = [0, 5, 10, 15, 20]
    
    private var splitedAmount: Double {
        let originAmount = Double(originAmountText) ?? 0
        let numberOfIndividuals = Double(numberOfIndividulIndex + 1)
        let tipPercent = Double(tipPercents[tipPercentIndex])
        
        return originAmount * (1 + tipPercent / 100) / numberOfIndividuals
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount of money", text: $originAmountText)
                        .keyboardType(.decimalPad)
                    Picker("Number of individuals", selection: $numberOfIndividulIndex) {
                        ForEach(1 ..< 10) { number in
                            Text("\(number)")
                        }
                    }
                }
                
                Section(header: Text("Percentage of tip")) {
                    Picker("Percentage of tip", selection: $tipPercentIndex) {
                        ForEach(0 ..< tipPercents.count) {
                            Text("\(tipPercents[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Amount of splited")) {
                    Text("$\(splitedAmount, specifier: "%.2f")")
                }
            }
            .navigationTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
