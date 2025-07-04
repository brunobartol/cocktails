import Foundation

enum ApiError: Error {
    case invalidURL
    case unauthorized
    case notFound
    case forbidden
    case internalServerError
    case decodingError(message: String)
    case emptyData
    case unknown
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .unauthorized:
            return "Unauthorized"
        case .notFound:
            return "Not found"
        case .forbidden:
            return "Forbidden"
        case .internalServerError:
            return "Internal server error"
        case .decodingError:
            return "Decoding error"
        case .emptyData:
            return "Empty data"
        default:
            return "Unknown error"
        }
    }
}
