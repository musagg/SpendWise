import Foundation

struct Transaction: Identifiable, Codable {
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var category: Category
    
    init(id: UUID = UUID(), title: String, amount: Double, date: Date = Date(), category: Category) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
    }
} 