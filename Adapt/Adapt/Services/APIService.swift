import Foundation
import Combine

final class APIService {
    static let shared = APIService()

    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.jsonDecoder = decoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        var urlComponents = URLComponents(url: Constants.apiBaseURL, resolvingAgainstBaseURL: false)!
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems

        guard let url = urlComponents.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = endpoint.body

        return urlSession.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                if let httpResponse = result.response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: T.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    enum NetworkError: Error {
        case badURL
        case transport(Error)
        case serverStatus(Int)
        case decoding(Error)
        case unknown
    }

    private func request<T: Decodable>(_ path: String,
                                       method: HTTPMethod,
                                       body: [String: Any]?,
                                       completion: @escaping (Result<T, NetworkError>) -> Void) {
        var urlComponents = URLComponents(url: Constants.apiBaseURL, resolvingAgainstBaseURL: false)
        urlComponents?.path = path
        guard let url = urlComponents?.url else {
            completion(.failure(.badURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body = body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.transport(error)))
                return
            }
            guard let http = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            guard (200...299).contains(http.statusCode), let data = data else {
                completion(.failure(.serverStatus(http.statusCode)))
                return
            }
            do {
                let decoded = try self.jsonDecoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decoding(error)))
            }
        }.resume()
    }

    // ADD to existing APIService class
    func generateDailyPlan(userId: UUID,
                           algorithmInputs: AlgorithmInputs,
                           completion: @escaping (Result<DailyPlanResponse, NetworkError>) -> Void) {
        let body: [String: Any] = [
            "userId": userId.uuidString,
            "algorithmInputs": [
                "userProfile": [
                    "goal": algorithmInputs.userProfile.goal,
                    "age": algorithmInputs.userProfile.age,
                    "sex": algorithmInputs.userProfile.sex,
                    "height_cm": algorithmInputs.userProfile.height_cm,
                    "activity_level": algorithmInputs.userProfile.activity_level,
                    "baseline_calories": algorithmInputs.userProfile.baseline_calories
                ],
                "currentWeight": algorithmInputs.currentWeight,
                "historicalData": [
                    "weightHistory": algorithmInputs.historicalData.weightHistory,
                    "calorieHistory": algorithmInputs.historicalData.calorieHistory,
                    "previousPlan": [
                        "calorieTarget": algorithmInputs.historicalData.previousPlan.calorieTarget,
                        "workoutCalorieEstimate": algorithmInputs.historicalData.previousPlan.workoutCalorieEstimate
                    ]
                ]
            ]
        ]
        
        request("/api/generateDailyPlan", method: .post, body: body, completion: completion)
    }
}


