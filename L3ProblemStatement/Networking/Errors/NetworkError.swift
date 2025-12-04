import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noInternet
    case requestFailed(statusCode: Int)
    case decodingFailed
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noInternet:
            return "No internet connection."
        case .requestFailed(let code):
            return "Request failed with status code \(code)."
        case .decodingFailed:
            return "Failed to decode response."
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

