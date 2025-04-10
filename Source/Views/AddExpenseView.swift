import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TransactionListViewModel
    
    @State private var title = ""
    @State private var amount = ""
    @State private var category = Category.food
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                Picker("Category", selection: $category) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text("\(category.icon) \(category.rawValue)")
                    }
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") {
                    if let amount = Double(amount), !title.isEmpty {
                        viewModel.addTransaction(Transaction(
                            title: title,
                            amount: amount,
                            category: category
                        ))
                        dismiss()
                    }
                }
            )
        }
    }
} 