import Combine

// MARK: - Random cocktail serivice protocol

protocol RandomCocktailServiceProtocol {
    func fetchRandom() -> AnyPublisher<CocktailDTO, ApiError>
}

// MARK: - Implementation

final class RandomCocktailService: RandomCocktailServiceProtocol {
    func fetchRandom() -> AnyPublisher<CocktailDTO, ApiError> {
        return NetworkManager.shared
            .request(Endpoint.randomCocktail.url, decodableType: CocktailsListResponseDTO.self)
            .tryCompactMap { $0.drinks.first }
            .mapError { _ in return ApiError.emptyData }
            .eraseToAnyPublisher()
    }
}

final class MockRandomCocktailService: RandomCocktailServiceProtocol {
    private let mockCocktail = CocktailDTO(id: "1100",
                                           name: "Mojito",
                                           category: "Cocktail",
                                           alcoholic: "Alcoholic",
                                           imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                                           instructions: "Place mint leaves and 1 lime wedge into a sturdy glass. Use a muddler and crush to release mint oils and lime juice. Add remaining lime wedges and 2 tablespoons sugar, and muddle again to release the lime juice. Do not strain the mixture. Fill the glass almost to the top with ice. Pour in rum and fill the glass with club soda. Stir, taste, and add more sugar if desired.",
                                           glass: "Highball glass",
                                           dateModified: "2016-11-04 09:17:09")
    
    func fetchRandom() -> AnyPublisher<CocktailDTO, ApiError> {
        Future<CocktailDTO, ApiError> { [weak self] promise in
            guard let self else { return }
            
            return promise(.success(mockCocktail))
        }.eraseToAnyPublisher()
    }
}
