//
//  AddressView.swift
//  Cupcake Corner
//
//  Created by bytedance on 2021/7/3.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            TextField("Name", text: $order.name)
            TextField("City", text: $order.city)
            TextField("Street", text: $order.street)
            TextField("Zip", text: $order.zip)
            
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Checkout")
                }
                .disabled(!order.validAddress)
            }
        }
        .navigationTitle("Address")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
