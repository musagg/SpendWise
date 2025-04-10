import Foundation

struct SplitTransaction: Identifiable, Codable {
    var id: UUID
    var transaction: Transaction
    var splitBetween: [Person]
    var paidBy: Person
    var splitType: SplitType
    var customSplits: [UUID: Double]? // Maps person ID to their share
    
    init(id: UUID = UUID(), 
         transaction: Transaction, 
         splitBetween: [Person], 
         paidBy: Person,
         splitType: SplitType = .equal,
         customSplits: [UUID: Double]? = nil) {
        self.id = id
        self.transaction = transaction
        self.splitBetween = splitBetween
        self.paidBy = paidBy
        self.splitType = splitType
        self.customSplits = customSplits
    }
    
    enum SplitType: String, Codable {
        case equal
        case percentage
        case custom
    }
    
    func amountForPerson(_ person: Person) -> Double {
        switch splitType {
        case .equal:
            return transaction.amount / Double(splitBetween.count)
        case .percentage:
            return (customSplits?[person.id] ?? 0) * transaction.amount / 100
        case .custom:
            return customSplits?[person.id] ?? 0
        }
    }
} 