//
//  AddExpense.swift
//  iExpense
//
//  Created by bytedance on 2021/6/28.
//

import SwiftUI

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

struct AddExpense: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expense: Expense
    @State private var amountText = ""
    @State private var type = ExpenseType.Personal
    @State private var name = ""
    
    func genExpenseItem() throws -> ExpenseItem {
        guard let amount = Double(amountText) else {
            throw "amountText not conform to Double"
        }
        return ExpenseItem(amount: amount, type: type, name: name)
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    Text("Pernsonal").tag(ExpenseType.Personal)
                    Text("Businsess").tag(ExpenseType.Business)
                }
                TextField("Amount", text: $amountText)
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add Expense")
            .navigationBarItems(trailing: Button("Save") {
                let item = try! genExpenseItem()
                expense.items.append(item)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddExpense(expense: Expense())
    }
}
