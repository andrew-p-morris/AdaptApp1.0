import Foundation

struct FoodLog: Codable, Identifiable {
    let id: UUID
    var date: Date
    var name: String
    var calories: Int
}


