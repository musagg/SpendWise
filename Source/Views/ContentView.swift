import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TransactionListViewModel()
    
    var body: some View {
        TabView {
            TransactionList(viewModel: viewModel)
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet")
                }
            
            NavigationView {
                SplitTransactionList(viewModel: viewModel)
            }
            .tabItem {
                Label("Split", systemImage: "person.2")
            }
            
            ExpenseStatsView(viewModel: viewModel)
                .tabItem {
                    Label("Statistics", systemImage: "chart.pie")
                }
            
            BudgetSettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Budget", systemImage: "gearshape")
                }
        }
    }
}

