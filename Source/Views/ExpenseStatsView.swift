import SwiftUI

struct ExpenseStatsView: View {
    @ObservedObject var viewModel: TransactionListViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Overview")) {
                    HStack {
                        Text("Total Expenses")
                        Spacer()
                        Text("$\(String(format: "%.2f", viewModel.totalExpenses))")
                            .foregroundColor(.red)
                    }
                    
                    HStack {
                        Text("Monthly Budget")
                        Spacer()
                        Text("$\(String(format: "%.2f", viewModel.monthlyBudget))")
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Remaining Budget")
                        Spacer()
                        Text("$\(String(format: "%.2f", viewModel.remainingBudget))")
                            .foregroundColor(viewModel.remainingBudget >= 0 ? .green : .red)
                    }
                }
                
                Section(header: Text("Category Breakdown")) {
                    ForEach(Category.allCases, id: \.self) { category in
                        let amount = viewModel.transactions
                            .filter { $0.category == category }
                            .reduce(0) { $0 + $1.amount }
                        
                        HStack {
                            Text("\(category.icon) \(category.rawValue)")
                            Spacer()
                            Text("$\(String(format: "%.2f", amount))")
                        }
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
} 