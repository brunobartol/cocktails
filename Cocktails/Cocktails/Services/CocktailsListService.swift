import Combine
import Foundation

// MARK: - Cocktails list service protocol -

protocol CocktailsListServiceProtocol {
    func fetchCocktailsList(_ query: String) -> AnyPublisher<CocktailsListResponseDTO, ApiError>
}

// MARK: - Implementation -

final class CocktailsListService: CocktailsListServiceProtocol {
    func fetchCocktailsList(_ query: String) -> AnyPublisher<CocktailsListResponseDTO, ApiError> {
        return NetworkManager.shared
            .request(Endpoint.cocktalisList(query).url, decodableType: CocktailsListResponseDTO.self)
            .eraseToAnyPublisher()
    }
}
