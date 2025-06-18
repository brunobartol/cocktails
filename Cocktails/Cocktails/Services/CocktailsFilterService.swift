import Combine
import Foundation

// MARK: - Cocktails list service protocol

protocol CocktailsFilterServiceProtocol {
    func fetchCategoriesFilterList() -> AnyPublisher<[CategoryFilterDTO], ApiError>
    func fetchGlassesFilterList() -> AnyPublisher<[GlassFilterDTO], ApiError>
    func fetchAlcoholicTypeFilterList() -> AnyPublisher<[AlcoholicTypeFilterDTO], ApiError>
    func search(categoryFilter: String?, glassFilter: String?, alcoholicTypeFilter: String?) -> AnyPublisher<[FilteredListItemDTO], ApiError>
}

// MARK: - Implementation

final class CocktailsFilterService: CocktailsFilterServiceProtocol {
    func fetchCategoriesFilterList() -> AnyPublisher<[CategoryFilterDTO], ApiError> {
        return NetworkManager.shared
            .request(Endpoint.categoryFilterList.url, decodableType: CategoryFilterListResponseDTO.self)
            .tryCompactMap { $0.drinks }
            .mapError { _ in return ApiError.emptyData }
            .eraseToAnyPublisher()
    }
    
    func fetchGlassesFilterList() -> AnyPublisher<[GlassFilterDTO], ApiError> {
        return NetworkManager.shared
            .request(Endpoint.glassFilterList.url, decodableType: GlassFilterListResponseDTO.self)
            .tryCompactMap { $0.drinks }
            .mapError { _ in return ApiError.emptyData }
            .eraseToAnyPublisher()
    }
    
    func fetchAlcoholicTypeFilterList() -> AnyPublisher<[AlcoholicTypeFilterDTO], ApiError> {
        return NetworkManager.shared
            .request(Endpoint.alcoholicTypeFilterList.url, decodableType: AlcoholicTypeFilterListResponseDTO.self)
            .tryCompactMap { $0.drinks }
            .mapError { _ in return ApiError.emptyData }
            .eraseToAnyPublisher()
    }
    
    func search(categoryFilter: String?, glassFilter: String?, alcoholicTypeFilter: String?) -> AnyPublisher<[FilteredListItemDTO], ApiError> {
        return NetworkManager.shared
            .request(Endpoint.filter(category: categoryFilter, glass: glassFilter, alcoholicType: alcoholicTypeFilter).url, decodableType: FilteredListResponseDTO.self)
            .tryCompactMap { $0.drinks }
            .mapError { error in return ApiError.emptyData }
            .eraseToAnyPublisher()
    }
}
