//
//  EditView.swift
//  Flashzilla
//
//  Created by bytedance on 2021/7/16.
//

import SwiftUI

struct EditView: View {
    @State private var cards = [Card]()
    @Environment(\.presentationMode) var presentationMode
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "cards.json") {
            do {
                cards = try JSONDecoder().decode([Card].self, from: data)
            } catch {
                print("Failed to load stored data")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button("New Card") {
                        cards.append(Card(prompt: "", answer: ""))
                    }
                }
                List(0..<cards.count, id: \.self) { index in
                    Section {
                        TextField("Prompt", text: $cards[index].prompt)
                        TextField("Answer", text: $cards[index].answer)
                    }
                }
            }
            .navigationTitle("Edit")
            .navigationBarItems(trailing: Button("Save") {
                if let data = try? JSONEncoder().encode(cards) {
                    UserDefaults.standard.setValue(data, forKey: "cards.json")
                }
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear(perform: loadData)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
