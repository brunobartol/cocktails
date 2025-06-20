import Combine

@testable import Cocktails

// MARK: - Mock implementation for testing -

final class MockCocktailsListService: CocktailsListServiceProtocol {
    private let mockCocktail = CocktailDTO(id: "1100",
                                           name: "Mojito",
                                           category: "Cocktail",
                                           alcoholic: "Alcoholic",
                                           imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                                           instructions: "Place mint leaves and 1 lime wedge into a sturdy glass. Use a muddler and crush to release mint oils and lime juice. Add remaining lime wedges and 2 tablespoons sugar, and muddle again to release the lime juice. Do not strain the mixture. Fill the glass almost to the top with ice. Pour in rum and fill the glass with club soda. Stir, taste, and add more sugar if desired.",
                                           glass: "Highball glass",
                                           dateModified: "2016-11-04 09:17:09",
                                           ingredients: ["White rum", "soda", "mint", "sugar", "lime"])
    
    private let mockCocktailsList = [
        CocktailDTO(id: "1",
                    name: "Mojito",
                    category: "Cocktail",
                    alcoholic: "Alcoholic",
                    imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                    instructions: "Place mint leaves and 1 lime wedge into a sturdy glass. Use a muddler and crush to release mint oils and lime juice. Add remaining lime wedges and 2 tablespoons sugar, and muddle again to release the lime juice. Do not strain the mixture. Fill the glass almost to the top with ice. Pour in rum and fill the glass with club soda. Stir, taste, and add more sugar if desired.",
                    glass: "Highball glass",
                    dateModified: "2016-11-04 09:17:09",
                    ingredients: ["White rum", "soda", "mint", "sugar", "lime"]),
        CocktailDTO(id: "2",
                    name: "Long Island",
                    category: "Cocktail",
                    alcoholic: "Alcoholic",
                    imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                    instructions: "Place mint leaves and 1 lime wedge into a sturdy glass. Use a muddler and crush to release mint oils and lime juice. Add remaining lime wedges and 2 tablespoons sugar, and muddle again to release the lime juice. Do not strain the mixture. Fill the glass almost to the top with ice. Pour in rum and fill the glass with club soda. Stir, taste, and add more sugar if desired.",
                    glass: "Highball glass",
                    dateModified: "2016-11-04 09:17:09",
                    ingredients: ["White rum", "soda", "mint", "sugar", "lime"]),
        CocktailDTO(id: "3",
                    name: "Negroni",
                    category: "Cocktail",
                    alcoholic: "Alcoholic",
                    imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                    instructions: "Place mint leaves and 1 lime wedge into a sturdy glass. Use a muddler and crush to release mint oils and lime juice. Add remaining lime wedges and 2 tablespoons sugar, and muddle again to release the lime juice. Do not strain the mixture. Fill the glass almost to the top with ice. Pour in rum and fill the glass with club soda. Stir, taste, and add more sugar if desired.",
                    glass: "Highball glass",
                    dateModified: "2016-11-04 09:17:09",
                    ingredients: ["White rum", "soda", "mint", "sugar", "lime"]),
        CocktailDTO(id: "4",
                    name: "Acapulco",
                    category: "Ordinary Drink",
                    alcoholic: "Alcoholic",
                    imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                    instructions: "Place mint leaves and 1 lime wedge into a sturdy glass. Use a muddler and crush to release mint oils and lime juice. Add remaining lime wedges and 2 tablespoons sugar, and muddle again to release the lime juice. Do not strain the mixture. Fill the glass almost to the top with ice. Pour in rum and fill the glass with club soda. Stir, taste, and add more sugar if desired.",
                    glass: "Highball glass",
                    dateModified: "2016-11-04 09:17:09",
                    ingredients: ["White rum", "soda", "mint", "sugar", "lime"]),
    ]
    
    func fetchCocktailsList(_ query: String) -> AnyPublisher<CocktailsListResponseDTO, ApiError> {
        if query.isEmpty {
            return Fail(error: ApiError.emptyData).eraseToAnyPublisher()
        }
        
        let filtered = mockCocktailsList.filter { $0.name.lowercased().contains(query.lowercased()) }
        return Just(CocktailsListResponseDTO(drinks: filtered))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
}
