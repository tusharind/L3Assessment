import Foundation

final class LoggerInterceptor: InterceptorProtocol {

    func intercept(_ request: URLRequest) async throws -> URLRequest {
        let myRequest = request

        logRequest(myRequest)

        return myRequest
    }

    private func logRequest(_ request: URLRequest) {

        if let url = request.url {
            print("URL: \(url.absoluteString)")
        }

    }

    func logResponse(data: Data, response: URLResponse, error: Error? = nil) {

        if let httpResponse = response as? HTTPURLResponse {

            if let url = httpResponse.url {
                print("URL: \(url.absoluteString)")
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
