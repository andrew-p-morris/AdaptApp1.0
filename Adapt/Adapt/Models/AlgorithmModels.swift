import Foundation

struct AlgorithmInputs: Codable {
    let userProfile: UserProfile
    let currentWeight: Double
    let historicalData: HistoricalData
}

struct UserProfile: Codable {
    let goal: String
    let age: Int
    let sex: String
    let height_cm: Double
    let activity_level: String
    let baseline_calories: Int
}

struct HistoricalData: Codable {
    let weightHistory: [Double]
    let calorieHistory: [Int]
    let previousPlan: PreviousPlan
}

struct PreviousPlan: Codable {
    let calorieTarget: Int
    let workoutCalorieEstimate: Int
}

struct DailyPlanResponse: Codable {
    let date: Date
    let calorieTarget: Int
    let workoutRoutine: WorkoutRoutine
}

struct WorkoutRoutine: Codable {
    let type: String
    let duration: Int
    let intensity: String
    let exercises: [String]
    let calorieEstimate: Int
}


