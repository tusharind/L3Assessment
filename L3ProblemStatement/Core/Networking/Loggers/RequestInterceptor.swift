import Foundation

protocol InterceptorProtocol {

    func intercept(_ request: URLRequest) async throws -> URLRequest

    func logRequest(_ request: URLRequest)

    func logResponse(data: Data, response: URLResponse, error: Error?)

}
