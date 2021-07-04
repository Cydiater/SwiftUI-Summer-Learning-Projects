//
//  CheckoutView.swift
//  Cupcake Corner
//
//  Created by bytedance on 2021/7/3.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var serverMessage: String = "Processing"
    
    func placeOrder() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(order)
            let url = URL(string: "https://reqres.in/api/cupcakes")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        serverMessage = "Network Error"
                    }
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    DispatchQueue.main.async {
                        serverMessage = "Server Error"
                    }
                    return
                }
                if let mimeType = response.mimeType,
                   mimeType == "application/json",
                   let data = data {
                    let decoder = JSONDecoder()
                    if let _ = try? decoder.decode(Order.self, from: data) {
                        DispatchQueue.main.async {
                            serverMessage = "Your order is placed."
                        }
                    }
                }
            }
            task.resume()
        } catch {
            DispatchQueue.main.async {
                serverMessage = "The order is invalid."
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                Image("cupcakes")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width)
                
                Text(serverMessage)
                    .font(.title)
            }
            .onAppear(perform: placeOrder)
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
