import SwiftUI
import Combine

final class CocktailsFilterSearchViewModel: ObservableObject {
    private let listService: CocktailsListServiceProtocol
    private let filteredIds: [String]
    private var cancellables = Set<AnyCancellable>()
    
    enum ViewState {
        case loading
        case success([CocktailModel])
        case error(message: String)
    }
    
    @Published var state: ViewState = .loading
    
    init(filteredIds: [String],
         listService: CocktailsListServiceProtocol) {
        self.filteredIds = filteredIds
        self.listService = listService
        
        fetchCocktails()
    }
    
    func fetchCocktails() {
        listService
            .fetchCocktailsList("")
            .receive(on: RunLoop.main)
            .replaceError(with: CocktailsListResponseDTO(drinks: []))
            .sink { [weak self] response in
                self?.state = .success(response.drinks.map { CocktailModel(from: $0) })
            }
            .store(in: &cancellables)
    }
}
