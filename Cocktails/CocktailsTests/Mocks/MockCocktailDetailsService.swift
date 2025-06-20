import Combine
@testable import Cocktails

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
        if id == mockCocktail.id {
            return Just(mockCocktail)
                .setFailureType(to: ApiError.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: .decodingError(message: "The data couldn’t be read because it isn’t in the correct format."))
            .eraseToAnyPublisher()
    }
}
