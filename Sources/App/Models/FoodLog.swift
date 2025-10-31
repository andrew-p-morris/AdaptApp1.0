import Vapor
import Fluent

final class FoodLog: Model, Content {
    static let schema = "food_logs"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "calories")
    var calories: Int
    
    @Field(key: "protein")
    var protein: Double?
    
    @Field(key: "carbs")
    var carbs: Double?
    
    @Field(key: "fat")
    var fat: Double?
    
    @Field(key: "timestamp")
    var timestamp: Date
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(id: UUID? = nil, name: String, calories: Int, protein: Double?, carbs: Double?, fat: Double?, timestamp: Date, userID: User.IDValue) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.timestamp = timestamp
        self.$user.id = userID
    }
}

