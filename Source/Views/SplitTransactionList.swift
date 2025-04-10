import SwiftUI

struct SplitTransactionList: View {
    @ObservedObject var viewModel: TransactionListViewModel
    @State private var showingAddSplit = false
    
    var body: some View {
        List {
            Section(header: Text("Balances")) {
                ForEach(viewModel.people) { person in
                    HStack {
                        Text(person.name)
                        Spacer()
                        Text(String(format: "%.2f", viewModel.balanceForPerson(person)))
                            .foregroundColor(viewModel.balanceForPerson(person) >= 0 ? .green : .red)
                    }
                }
            }
            
            Section(header: Text("Split Transactions")) {
                ForEach(viewModel.splitTransactions) { split in
                    VStack(alignment: .leading) {
                        Text(split.transaction.title)
                            .font(.headline)
                        Text("Paid by: \(split.paidBy.name)")
                            .font(.subheadline)
                        Text("Amount: $\(String(format: "%.2f", split.transaction.amount))")
                            .font(.subheadline)
                        Text("Split between: \(split.splitBetween.map { $0.name }.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Split Expenses")
        .navigationBarItems(trailing:
            Button(action: { showingAddSplit = true }) {
                Image(systemName: "plus")
            }
        )
        .sheet(isPresented: $showingAddSplit) {
            SplitExpenseView(viewModel: viewModel)
        }
    }
} 