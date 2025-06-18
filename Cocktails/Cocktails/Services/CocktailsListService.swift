import Combine
import Foundation

// MARK: - Cocktails list service protocol -

protocol CocktailsListServiceProtocol {
    func fetchCocktailsList(_ query: String) -> AnyPublisher<CocktailsListResponseDTO, ApiError>
}

// MARK: - Implementation -

final class CocktailsListService: CocktailsListServiceProtocol {
    func fetchCocktailsList(_ query: String) -> AnyPublisher<CocktailsListResponseDTO, ApiError> {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(query)") else {
            return Fail(error: ApiError.invalidQuery).eraseToAnyPublisher()
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
            .decode(type: CocktailsListResponseDTO.self, decoder: JSONDecoder())
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
