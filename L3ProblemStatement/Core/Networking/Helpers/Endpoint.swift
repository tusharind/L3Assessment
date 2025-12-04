import Foundation

struct Endpoint {
    let path: String
    let method: HTTPMethod
    var body: Encodable? = nil

    func makeRequest(
        baseURL: String = "https://jsonplaceholder.typicode.com/todos"
    ) throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

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
