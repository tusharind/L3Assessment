import Foundation

struct Endpoint {
    let path: String
    let method: HTTPMethod
    var queryItems: [URLQueryItem] = []
    var body: Encodable? = nil
    var headers: [String: String] = [:]

    func makeRequest(baseURL: String = "https://jsonplaceholder.typicode.com/todos") throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
        }

        return request
    }
}
