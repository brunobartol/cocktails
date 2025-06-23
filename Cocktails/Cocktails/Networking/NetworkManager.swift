import Combine
import Foundation

// MARK: - NetworkManager protocol

protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ urlString: String, decodableType: T.Type) -> AnyPublisher<T, ApiError>
}

// MARK: - Implementation

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(_ urlString: String, decodableType: T.Type) -> AnyPublisher<T, ApiError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.invalidURL).eraseToAnyPublisher()
        }
        let request = URLRequest(url: url)
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw ApiError.unknown
                }
                
                switch httpResponse.statusCode {
                case 200:
                    return data
                case 401:
                    throw ApiError.unauthorized
                case 404:
                    throw ApiError.notFound
                case 403:
                    throw ApiError.forbidden
                case 500..<600:
                    throw ApiError.internalServerError
                default:
                    throw ApiError.unknown
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? ApiError {
                    return error
                }
                
                if let decodingError = error as? DecodingError {
                    return ApiError.decodingError(message: decodingError.localizedDescription)
                }
                
                return ApiError.unknown
            }
            .eraseToAnyPublisher()
    }
}
