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
            .mapError { _ in return ApiError.emptyData }
            .eraseToAnyPublisher()
    }
}

// MARK: - Mock implementation for testing

final class MockCocktailDetailsService: CocktailDetailsServiceProtocol {
    private let mockCocktail = CocktailDTO(id: "1100",
                                           name: "Mojito",
                                           category: "Cocktail",
                                           alcoholic: "Alcoholic",
                                           imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                                           instructions: "Place mint leaves and 1 lime wedge into a sturdy glass. Use a muddler and crush to release mint oils and lime juice. Add remaining lime wedges and 2 tablespoons sugar, and muddle again to release the lime juice. Do not strain the mixture. Fill the glass almost to the top with ice. Pour in rum and fill the glass with club soda. Stir, taste, and add more sugar if desired.",
                                           glass: "Highball glass",
                                           dateModified: "2016-11-04 09:17:09",
                                           ingredients: ["White rum", "soda", "mint", "sugar", "lime"])
    
    func fetchCocktailDetails(_ id: String) -> AnyPublisher<CocktailDTO, ApiError> {
        Future<CocktailDTO, ApiError> { [weak self] promise in
            guard let self else { return }
            
            if id == mockCocktail.id {
                return promise(.success(mockCocktail))
            }
            
            return promise(.failure(.decodingError(message: "The data couldn’t be read because it isn’t in the correct format.")))
        }.eraseToAnyPublisher()
    }
}
