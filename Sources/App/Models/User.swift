import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "goal")
    var goal: String
    
    @Field(key: "daily_calorie_target")
    var dailyCalorieTarget: Int
    
    @Children(for: \.$user)
    var dailyPlans: [DailyPlan]
    
    @Children(for: \.$user)
    var foodLogs: [FoodLog]
    
    init() { }
    
    init(id: UUID? = nil, name: String, email: String, goal: String, dailyCalorieTarget: Int) {
        self.id = id
        self.name = name
        self.email = email
        self.goal = goal
        self.dailyCalorieTarget = dailyCalorieTarget
    }
}

