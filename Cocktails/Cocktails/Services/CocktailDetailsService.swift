import Combine
import Foundation

// MARK: - Cocktails list service protocol

protocol CocktailDetailsServiceProtocol {
    func fetchCocktailDetails(_ id: String) -> AnyPublisher<CocktailDTO, ApiError>
}

// MARK: - Implementation

final class CocktailDetailsService: CocktailDetailsServiceProtocol {
    func fetchCocktailDetails(_ id: String) -> AnyPublisher<CocktailDTO, ApiError> {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(id)") else {
            return Future<CocktailDTO, ApiError> { promise in
                return promise(.failure(ApiError.invalidQuery))
            }.eraseToAnyPublisher()
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
            .tryCompactMap { $0.drinks.first }
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

// MARK: - Mock implementation for testing

final class MockCocktailDetailsService: CocktailDetailsServiceProtocol {
    private let mockCocktail = CocktailDTO(id: "test",
                                           name: "Mojito",
                                           category: "Cocktail",
                                           alcoholic: "Alcoholic",
                                           imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                                           instructions: "Place mint leaves and 1 lime wedge into a sturdy glass. Use a muddler and crush to release mint oils and lime juice. Add remaining lime wedges and 2 tablespoons sugar, and muddle again to release the lime juice. Do not strain the mixture. Fill the glass almost to the top with ice. Pour in rum and fill the glass with club soda. Stir, taste, and add more sugar if desired.",
                                           glass: "Highball glass",
                                           dateModified: "2016-11-04 09:17:09")
    
    func fetchCocktailDetails(_ id: String) -> AnyPublisher<CocktailDTO, ApiError> {
        Future<CocktailDTO, ApiError> { [weak self] promise in
            guard let self else { return }
            
            return promise(.success(mockCocktail))
        }.eraseToAnyPublisher()
    }
}
