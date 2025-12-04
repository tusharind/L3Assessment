import Foundation

protocol InterceptorProtocol {
    func intercept(_ request: URLRequest) async throws -> URLRequest
}
