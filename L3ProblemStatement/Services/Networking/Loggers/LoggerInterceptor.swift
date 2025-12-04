import Foundation

final class LoggerInterceptor: RequestInterceptor {

    func intercept(_ request: URLRequest) async throws -> URLRequest {
        let myRequest = request

        logRequest(myRequest)

        return myRequest
    }

    private func logRequest(_ request: URLRequest) {

        if let url = request.url {
            print("URL: \(url.absoluteString)")
        }

        if let method = request.httpMethod {
            print("Method: \(method)")
        }

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers:")
            headers.forEach { key, value in
                print("   \(key): \(value)")
            }
        }

        if let body = request.httpBody,
            let bodyString = String(data: body, encoding: .utf8)
        {
            print("Body:")
            print(bodyString)
        }

    }

    func logResponse(data: Data, response: URLResponse, error: Error? = nil) {

        if let httpResponse = response as? HTTPURLResponse {
            let statusIndicator =
                (200..<300).contains(httpResponse.statusCode)
                ? "SUCCESS" : "FAILED"
            print(
                "[\(statusIndicator)] Status Code: \(httpResponse.statusCode)"
            )

            if let url = httpResponse.url {
                print("URL: \(url.absoluteString)")
            }

            print("Headers:")
            httpResponse.allHeaderFields.forEach { key, value in
                print("   \(key): \(value)")
            }

        }

        if let error = error {
            print("Error: \(error.localizedDescription)")
        }

        if let jsonString = String(data: data, encoding: .utf8) {
            print("Response Body:")
            print(jsonString)
        }

    }
}
