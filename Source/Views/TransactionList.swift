import SwiftUI

struct TransactionList: View {
    @ObservedObject var viewModel: TransactionListViewModel
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                RecentTransactionList(viewModel: viewModel)
                
                ForEach(viewModel.transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.deleteTransaction(viewModel.transactions[index])
                    }
                }
            }
            .navigationTitle("Expenses")
            .navigationBarItems(trailing:
                Button(action: { showingAddExpense = true }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(viewModel: viewModel)
            }
        }
    }
} 