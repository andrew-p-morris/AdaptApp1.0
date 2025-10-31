import Fluent

struct CreateFoodLog: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("food_logs")
            .id()
            .field("name", .string, .required)
            .field("calories", .int, .required)
            .field("protein", .double)
            .field("carbs", .double)
            .field("fat", .double)
            .field("timestamp", .datetime, .required)
            .field("user_id", .uuid, .required, .references("users", "id", onDelete: .cascade))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("food_logs").delete()
    }
}


