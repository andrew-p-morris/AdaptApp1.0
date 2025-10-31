import Vapor

public func routes(_ app: Application) throws {
    try app.register(collection: DailyPlanController())
    
    app.get("health") { _ in
        "ok"
    }
}


