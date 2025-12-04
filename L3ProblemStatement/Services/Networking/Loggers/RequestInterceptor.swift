import Foundation

protocol RequestInterceptor {
    func intercept(_ request: URLRequest) async throws -> URLRequest
}
