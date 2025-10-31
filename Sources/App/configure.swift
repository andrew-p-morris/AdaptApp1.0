import Vapor
import Fluent
import FluentSQLiteDriver

public func configure(_ app: Application) throws {
    // Database: SQLite file for local development
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // Migrations
    app.migrations.add(CreateUser())
    app.migrations.add(CreateDailyPlan())
    app.migrations.add(CreateFoodLog())

    // Routes
    try routes(app)
}


