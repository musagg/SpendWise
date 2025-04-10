import SwiftUI

struct BudgetSettingsView: View {
    @ObservedObject var viewModel: TransactionListViewModel
    @State private var newBudget: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Monthly Budget")) {
                    TextField("Enter budget amount", text: $newBudget)
                        .keyboardType(.decimalPad)
                    
                    Button("Update Budget") {
                        if let amount = Double(newBudget) {
                            viewModel.updateBudget(amount)
                            newBudget = ""
                        }
                    }
                }
                
                Section(header: Text("Current Budget")) {
                    Text("$\(String(format: "%.2f", viewModel.monthlyBudget))")
                }
            }
            .navigationTitle("Budget Settings")
        }
    }
} 