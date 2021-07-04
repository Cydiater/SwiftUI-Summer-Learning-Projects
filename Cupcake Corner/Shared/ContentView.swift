//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/7/3.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    Picker("Select your cake type", selection: $order.cupcakeType) {
                        Text("StrawBerry").tag(CupcakeType.strawberry)
                        Text("Vanilla").tag(CupcakeType.vanllia)
                        Text("Chocolate").tag(CupcakeType.chocolate)
                    }
                    
                    Stepper("Number of cakes: \(order.orderAmount)", value: $order.orderAmount)
                }

                Section {
                    Toggle("Special request", isOn: $order.specialRequirement.animation())
                    if order.specialRequirement {
                        Toggle("More forst", isOn: $order.moreFrost)
                            .transition(.move(edge: .top))
                        Toggle("More sprinkle", isOn: $order.moreSprinkle)
                            .transition(.move(edge: .top))
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Address")
                    }
                }
                
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
