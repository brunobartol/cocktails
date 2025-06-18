import Combine
import SwiftUI

final class CocktailListViewModel: ObservableObject {
    enum ViewState {
        case success(cocktails: [CocktailModel])
        case error(message: String?)
    }
    
    @Published var state = ViewState.success(cocktails: [])
    @Published var searchText = ""
    
    private let service: CocktailsListServiceProtocol
    private(set) var cancellables = Set<AnyCancellable>()
    
    init(service: CocktailsListServiceProtocol) {
        self.service = service
        
        setupSearchTextBinding()
    }
    
    private func setupSearchTextBinding() {
        $searchText
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weak self] query in
                guard let self else {
                    return Just(CocktailsListResponseDTO(drinks: [])).eraseToAnyPublisher()
                }
                
                return service
                    .fetchCocktailsList(query)
                    .replaceError(with: CocktailsListResponseDTO(drinks: []))
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] cocktails in
                self?.state = .success(cocktails: cocktails.drinks.map { CocktailModel(from: $0) })
                
            }
            .store(in: &cancellables)
    }
}

// MARK: - Constants -

fileprivate struct Constants {
    private init() {}
    
    static let errorMessage = "Oops! Something went wrong..."
}
