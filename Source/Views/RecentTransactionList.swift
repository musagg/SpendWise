import SwiftUI

struct RecentTransactionList: View {
    @ObservedObject var viewModel: TransactionListViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Recent Transactions")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.transactions.prefix(5)) { transaction in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(transaction.category.icon)
                                .font(.title)
                            Text(transaction.title)
                                .font(.caption)
                            Text("$\(String(format: "%.2f", transaction.amount))")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
} 