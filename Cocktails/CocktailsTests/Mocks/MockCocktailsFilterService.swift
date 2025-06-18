import Combine
@testable import Cocktails

final class MockCocktailsFilterService: CocktailsFilterServiceProtocol {
    private let mockCategoriesList: [CategoryFilterDTO] = [
        CategoryFilterDTO(category: "Cocktail"),
        CategoryFilterDTO(category: "Ordinary Drink"),
        CategoryFilterDTO(category: "Punch / Party Drink"),
        CategoryFilterDTO(category: "Shake"),
        CategoryFilterDTO(category: "Other / Unknown")
    ]
    
    private let mockGlassFilterList: [GlassFilterDTO] = [
        GlassFilterDTO(glass: "Highball glass"),
        GlassFilterDTO(glass: "Old-fashioned glass"),
        GlassFilterDTO(glass: "Cocktail glass"),
        GlassFilterDTO(glass: "Irish coffee cup"),
        GlassFilterDTO(glass: "Whiskey Glass"),
        GlassFilterDTO(glass: "Collins glass")
    ]
    
    private let mockAlcoholicTypeFilterList: [AlcoholicTypeFilterDTO] = [
        AlcoholicTypeFilterDTO(alcoholicType: "Alcoholic"),
        AlcoholicTypeFilterDTO(alcoholicType: "Non alcoholic"),
        AlcoholicTypeFilterDTO(alcoholicType: "Optional alcohol")
    ]
    
    func fetchCategoriesFilterList() -> AnyPublisher<[CategoryFilterDTO], ApiError> {
        Just(mockCategoriesList)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchGlassesFilterList() -> AnyPublisher<[GlassFilterDTO], ApiError> {
        Just(mockGlassFilterList)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchAlcoholicTypeFilterList() -> AnyPublisher<[AlcoholicTypeFilterDTO], ApiError> {
        Just(mockAlcoholicTypeFilterList)
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
    
    func search(categoryFilter: String?, glassFilter: String?, alcoholicTypeFilter: String?) -> AnyPublisher<[FilteredListItemDTO], ApiError> {
        Just([])
            .setFailureType(to: ApiError.self)
            .eraseToAnyPublisher()
    }
}
