import Foundation

struct DailyPlan: Codable, Identifiable {
    let id: UUID
    var date: Date
    var targetCalories: Int
    var consumedCalories: Int
    var notes: String?
}


