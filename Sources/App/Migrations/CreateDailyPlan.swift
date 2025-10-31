import Fluent

struct CreateDailyPlan: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("daily_plans")
            .id()
            .field("date", .datetime, .required)
            .field("calorie_target", .int, .required)
            .field("workout_routine", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("daily_plans").delete()
    }
}


