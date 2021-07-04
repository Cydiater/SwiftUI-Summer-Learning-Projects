//
//  ContentView.swift
//  Shared
//
//  Created by bytedance on 2021/6/28.
//

import SwiftUI

enum ExpenseType: String, Identifiable, Codable {
    case Personal
    case Business
    
    var id: String {
        self.rawValue
    }
}

struct ExpenseItem: Codable, Identifiable {
    var id = UUID()
    var amount: Double
    var type: ExpenseType
    var name: String
}

class Expense: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            let data = try! encoder.encode(items)
            UserDefaults.standard.set(data, forKey: "expense")
        }
    }
    
    init() {
        if let json = UserDefaults.standard.value(forKey: "expense") as? Data {
            let decoder = JSONDecoder()
            self.items = try! decoder.decode([ExpenseItem].self, from: json)
        }
    }
}

struct ContentView: View {
    @ObservedObject var expense = Expense()
    @State private var showingAddExpense = false;
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expense.items) { item in
                    HStack {
                        VStack {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type.rawValue)
                                .font(.subheadline)
                        }
                        Spacer()
                        Image(systemName: "dollarsign.circle")
                        Text(String(item.amount))
                    }
                }
                .onDelete(perform: { indexSet in
                    removeRow(indexSet)
                })
            }
            .navigationTitle("iExpense")
            .navigationBarItems(trailing: Button(action: {
                showingAddExpense.toggle()
            }) {
                Image(systemName: "plus.circle")
            } .sheet(isPresented: $showingAddExpense) {
                AddExpense(expense: expense)
            })
        }
    }
    
    func removeRow(_ indexSet: IndexSet) {
        expense.items.remove(atOffsets: indexSet)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let expense = Expense()
        expense.items.append(ExpenseItem(amount: 10.5, type: ExpenseType.Business, name: "Brunch"))
        expense.items.append(ExpenseItem(amount: 5.05, type: ExpenseType.Personal, name: "Dinner"))
        return ContentView(expense: expense)
    }
}
