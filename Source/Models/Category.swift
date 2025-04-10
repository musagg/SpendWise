import Foundation

enum Category: String, CaseIterable, Codable {
    case food = "Food"
    case transportation = "Transportation"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case utilities = "Utilities"
    case health = "Health"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .food: return "🍔"
        case .transportation: return "🚗"
        case .entertainment: return "🎮"
        case .shopping: return "🛍"
        case .utilities: return "💡"
        case .health: return "💊"
        case .other: return ""
        }
    }
} 
