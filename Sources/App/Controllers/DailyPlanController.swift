import Vapor

struct DailyPlanController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        api.post("generateDailyPlan", use: generateDailyPlan)
    }
    
    func generateDailyPlan(req: Request) throws -> EventLoopFuture<DailyPlanResponse> {
        let requestData = try req.content.decode(GeneratePlanRequest.self)
        
        // Call AI/ML algorithm
        let dailyPlan = generateAdaptivePlan(inputs: requestData.algorithmInputs)
        
        return req.eventLoop.makeSucceededFuture(dailyPlan)
    }
}

// REQUEST/RESPONSE MODELS
struct GeneratePlanRequest: Content {
    let userId: UUID
    let algorithmInputs: AlgorithmInputs
}

struct AlgorithmInputs: Content {
    let userProfile: UserProfile
    let currentWeight: Double
    let historicalData: HistoricalData
}

struct UserProfile: Content {
    let goal: String
    let age: Int
    let sex: String
    let height_cm: Double
    let activity_level: String
    let baseline_calories: Int
}

struct HistoricalData: Content {
    let weightHistory: [Double]
    let calorieHistory: [Int]
    let previousPlan: PreviousPlan
}

struct PreviousPlan: Content {
    let calorieTarget: Int
    let workoutCalorieEstimate: Int
}

struct DailyPlanResponse: Content {
    let date: Date
    let calorieTarget: Int
    let workoutRoutine: WorkoutRoutine
}

struct WorkoutRoutine: Content {
    let type: String
    let duration: Int
    let intensity: String
    let exercises: [String]
    let calorieEstimate: Int
}

