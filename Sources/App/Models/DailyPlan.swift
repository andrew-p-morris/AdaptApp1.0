import Vapor
import Fluent

final class DailyPlan: Model, Content {
    static let schema = "daily_plans"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "date")
    var date: Date
    
    @Field(key: "calorie_target")
    var calorieTarget: Int
    
    @Field(key: "workout_routine")
    var workoutRoutine: String
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(id: UUID? = nil, date: Date, calorieTarget: Int, workoutRoutine: String, userID: User.IDValue) {
        self.id = id
        self.date = date
        self.calorieTarget = calorieTarget
        self.workoutRoutine = workoutRoutine
        self.$user.id = userID
    }
}

