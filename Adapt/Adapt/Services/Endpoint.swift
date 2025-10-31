import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndpointType {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

enum Endpoint: EndpointType {
    case login(email: String, password: String)
    case dailyPlan(date: Date)

    var path: String {
        switch self {
        case .login:
            return "/api/auth/login"
        case .dailyPlan:
            return "/api/dailyPlan"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .dailyPlan:
            return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .dailyPlan(let date):
            let formatter = ISO8601DateFormatter()
            return [URLQueryItem(name: "date", value: formatter.string(from: date))]
        case .login:
            return nil
        }
    }

    var body: Data? {
        switch self {
        case .login(let email, let password):
            let payload = ["email": email, "password": password]
            return try? JSONSerialization.data(withJSONObject: payload, options: [])
        case .dailyPlan:
            return nil
        }
    }
}


