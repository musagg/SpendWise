import Foundation
import Combine

class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var splitTransactions: [SplitTransaction] = []
    @Published var people: [Person] = []
    @Published var monthlyBudget: Double = 1000.0
    
    private let userDefaults = UserDefaults.standard
    private let transactionsKey = "transactions"
    private let splitTransactionsKey = "splitTransactions"
    private let peopleKey = "people"
    private let budgetKey = "monthlyBudget"
    
    init() {
        loadTransactions()
        loadSplitTransactions()
        loadPeople()
        loadBudget()
    }
    
    // Transaction Methods
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        saveTransactions()
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
        saveTransactions()
    }
    
    private func loadTransactions() {
        if let data = userDefaults.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }
    
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            userDefaults.set(encoded, forKey: transactionsKey)
        }
    }
    
    // Budget Methods
    func updateBudget(_ amount: Double) {
        monthlyBudget = amount
        userDefaults.set(amount, forKey: budgetKey)
    }
    
    private func loadBudget() {
        monthlyBudget = userDefaults.double(forKey: budgetKey)
        if monthlyBudget == 0 {
            monthlyBudget = 1000.0
            userDefaults.set(monthlyBudget, forKey: budgetKey)
        }
    }
    
    // Split Transaction Methods
    func addPerson(_ person: Person) {
        people.append(person)
        savePeople()
    }
    
    func addSplitTransaction(_ splitTransaction: SplitTransaction) {
        splitTransactions.append(splitTransaction)
        saveSplitTransactions()
    }
    
    func deleteSplitTransaction(_ splitTransaction: SplitTransaction) {
        splitTransactions.removeAll { $0.id == splitTransaction.id }
        saveSplitTransactions()
    }
    
    func balanceForPerson(_ person: Person) -> Double {
        var balance = 0.0
        
        for split in splitTransactions {
            if split.paidBy.id == person.id {
                balance += split.transaction.amount
            }
            if split.splitBetween.contains(where: { $0.id == person.id }) {
                balance -= split.amountForPerson(person)
            }
        }
        
        return balance
    }
    
    private func loadSplitTransactions() {
        if let data = userDefaults.data(forKey: splitTransactionsKey),
           let decoded = try? JSONDecoder().decode([SplitTransaction].self, from: data) {
            splitTransactions = decoded
        }
    }
    
    private func saveSplitTransactions() {
        if let encoded = try? JSONEncoder().encode(splitTransactions) {
            userDefaults.set(encoded, forKey: splitTransactionsKey)
        }
    }
    
    private func loadPeople() {
        if let data = userDefaults.data(forKey: peopleKey),
           let decoded = try? JSONDecoder().decode([Person].self, from: data) {
            people = decoded
        }
    }
    
    private func savePeople() {
        if let encoded = try? JSONEncoder().encode(people) {
            userDefaults.set(encoded, forKey: peopleKey)
        }
    }
    
    // Statistics Methods
    var totalExpenses: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    var remainingBudget: Double {
        monthlyBudget - totalExpenses
    }
    
    func expensesForCategory(_ category: Category) -> Double {
        transactions
            .filter { $0.category == category }
            .reduce(0) { $0 + $1.amount }
    }
    
    var recentTransactions: [Transaction] {
        Array(transactions.prefix(5))
    }
} 