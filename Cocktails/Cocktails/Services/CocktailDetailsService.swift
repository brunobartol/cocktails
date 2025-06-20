import Combine
import Foundation

// MARK: - Cocktails list service protocol

protocol CocktailDetailsServiceProtocol {
    func fetchCocktailDetails(_ id: String) -> AnyPublisher<CocktailDTO, ApiError>
}

// MARK: - Implementation

final class CocktailDetailsService: CocktailDetailsServiceProtocol {
    func fetchCocktailDetails(_ id: String) -> AnyPublisher<CocktailDTO, ApiError> {
        return NetworkManager.shared
            .request(Endpoint.cocktailDetails(id).url, decodableType: CocktailsListResponseDTO.self)
            .tryCompactMap { $0.drinks.first }
            .mapError { error in
                guard let apiError = error as? ApiError else {
                    return ApiError.emptyData
                }
                
                return apiError
            }
            .eraseToAnyPublisher()
    }
}
