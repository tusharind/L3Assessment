import Foundation

final class NetworkClient: NetworkClientProtocol {

    private let interceptor: RequestInterceptor
    private let session: URLSession

    init(
        interceptor: RequestInterceptor,
        session: URLSession = .shared
    ) {
        self.interceptor = interceptor
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint, baseURL: String)
        async throws -> T
    {

        guard NetworkMonitor.shared.isConnected else {
            throw NetworkError.noInternet
        }

        var request = try endpoint.makeRequest(baseURL: baseURL)

        request = try await interceptor.intercept(request)

        let (data, response): (Data, URLResponse)
        var requestError: Error?

        do {
            (data, response) = try await session.data(for: request)
        } catch {
            requestError = error
            throw NetworkError.unknown(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(NSError(domain: "", code: -1))
        }

        if let logger = interceptor as? LoggerInterceptor {
            logger.logResponse(
                data: data,
                response: httpResponse,
                error: requestError
            )
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.requestFailed(
                statusCode: httpResponse.statusCode
            )
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

