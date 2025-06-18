import Combine

@testable import Cocktails

// MARK: - Mock implementation for testing -

final class MockCocktailsListService: CocktailsListServiceProtocol {
    private let mockCocktailsList = [
        CocktailDTO(id: "1",
                    name: "Mojito",
                    category: "Cocktail",
                    alcoholic: "Alcoholic",
                    imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                    ingredients: "White rum, soda, mint, sugar, lime"),
        CocktailDTO(id: "2",
                    name: "Long Island",
                    category: "Cocktail",
                    alcoholic: "Alcoholic",
                    imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                    ingredients: "White rum, soda, mint, sugar, lime"),
        CocktailDTO(id: "3",
                    name: "Negroni",
                    category: "Cocktail",
                    alcoholic: "Alcoholic",
                    imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                    ingredients: "White rum, soda, mint, sugar, lime"),
        CocktailDTO(id: "4",
                    name: "Acapulco",
                    category: "Ordinary Drink",
                    alcoholic: "Alcoholic",
                    imageUrl: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg",
                    ingredients: "Light rum, Triple sec, Lime juice, sugar, Egg white, Mint"),
    ]
    
    func fetchCocktailsList(_ query: String) -> AnyPublisher<CocktailsListResponseDTO, ApiError> {
        if query.isEmpty {
            return Fail(error: ApiError.invalidQuery).eraseToAnyPublisher()
        }
        
        let filtered = mockCocktailsList.filter { $0.name.lowercased().contains(query.lowercased()) }
        return Just(CocktailsListResponseDTO(drinks: filtered))
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
}
