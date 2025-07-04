import Foundation

enum ApiError: Error {
    case invalidQuery
    case unauthorized
    case notFound
    case forbidden
    case internalServerError
    case decodingError(message: String)
    case unknown
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidQuery:
            return "Invalid query"
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
        default:
            return "Unknown error"
        }
    }
}
