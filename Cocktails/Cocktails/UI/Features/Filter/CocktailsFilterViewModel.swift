import Combine
import SwiftUI

final class CocktailsFilterViewModel: ObservableObject {
    private let filterService: CocktailsFilterServiceProtocol
    private(set) var cancellables = Set<AnyCancellable>()
    
    enum ViewState {
        case idle
        case loading
        case success(filterModel: CocktailsFilterModel)
        case search(filteredIds: [String])
        case error(message: String)
    }
    
    struct FilterSelection {
        var categoryFilter: Filter?
        var glassFilter: Filter?
        var alcoholicTypeFilter: Filter?
        
        var isEmpty: Bool {
            categoryFilter == nil && glassFilter == nil && alcoholicTypeFilter == nil
        }
    }
    
    @Published var state: ViewState = .idle
    @Published var selectedFilters = FilterSelection()
    
    init(filterService: CocktailsFilterServiceProtocol) {
        self.filterService = filterService
    }
    
    func fetchFilters() {
        state = .loading
        
        let categoriesPublisher = filterService.fetchCategoriesFilterList()
        let glassesPublisher = filterService.fetchGlassesFilterList()
        let alcoholicTypesPublisher = filterService.fetchAlcoholicTypeFilterList()
        
        Publishers.Zip3(categoriesPublisher, glassesPublisher, alcoholicTypesPublisher)
            .receive(on: RunLoop.main)
            .catch({ error in
                Just(([], [], []))
            })
            .sink { _ in
                ()
            } receiveValue: { [weak self] (categoriesFilters, glassesFilters, alcoholicTypesFilters) in
                guard let self else { return }
                
                let categories = categoriesFilters.map { Filter(type: .category, value: $0.category) }
                let glasses = glassesFilters.map { Filter(type: .glass, value: $0.glass) }
                let alcoholicTypes = alcoholicTypesFilters.map { Filter(type: .alcoholicType, value: $0.alcoholicType) }
                let allFilters = categories + glasses + alcoholicTypes
                
                state = .success(filterModel: CocktailsFilterModel(allFilters: allFilters, filteredSearch: []))
            }
            .store(in: &cancellables)
    }
    
    func isActiveFilter(_ id: String) -> Bool {
        if case .success(_) = state {
            let matchesCategoryFilter = selectedFilters.categoryFilter?.id == id
            let matchesGlassFilter = selectedFilters.glassFilter?.id == id
            let matchesAlcoholicTypeFilter = selectedFilters.alcoholicTypeFilter?.id == id
            
            return matchesCategoryFilter || matchesGlassFilter || matchesAlcoholicTypeFilter
        }
        
        return false
    }
    
    func toggleFilter(_ filter: Filter) {
        switch filter.type {
        case .category:
            selectedFilters.categoryFilter = selectedFilters.categoryFilter?.id == filter.id ? nil : filter
        case .glass:
            selectedFilters.glassFilter = selectedFilters.glassFilter?.id == filter.id ? nil : filter
        case .alcoholicType:
            selectedFilters.alcoholicTypeFilter = selectedFilters.alcoholicTypeFilter?.id == filter.id ? nil : filter
        }
    }
    
    func resetFilters() {
        selectedFilters.categoryFilter = nil
        selectedFilters.glassFilter = nil
        selectedFilters.alcoholicTypeFilter = nil
    }
    
    func search() {
        filterService
            .search(categoryFilter: selectedFilters.categoryFilter?.value,
                    glassFilter: selectedFilters.glassFilter?.value,
                    alcoholicTypeFilter: selectedFilters.alcoholicTypeFilter?.value)
            .receive(on: RunLoop.main)
            .replaceError(with: [])
            .sink { completion in
                ()
            } receiveValue: { [weak self] listItems in
                guard let self else { return }
                
                if case .success(_) = self.state {
                    let filteredIds = listItems.map { $0.id }
                    state = .search(filteredIds: filteredIds)
                }
            }
            .store(in: &cancellables)
    }
}
