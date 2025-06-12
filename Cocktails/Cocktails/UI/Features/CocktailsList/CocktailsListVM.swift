import Combine
import SwiftUI

final class CocktailsListVM: ObservableObject {
    struct ViewState {
        var cocktails = [CocktailModel]()
        var errorMessage: String? = nil
    }
    
    @Published var state = ViewState()
    
    private let service: CocktailsListServiceProtocol
    private(set) var cancellables = Set<AnyCancellable>()
    
    init(service: CocktailsListServiceProtocol) {
        self.service = service
        
        search("")
    }
    
    func search(_ query: String) {
        service.fetchCocktailsList(query)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    ()
                case .failure(_):
                    state.cocktails = []
                    state.errorMessage = Constants.errorMessage
                }
            } receiveValue: { [weak self] result in
                self?.state.cocktails = result.drinks.map { CocktailModel(from: $0) }
                self?.state.errorMessage = nil
            }
            .store(in: &cancellables)
    }
}

// MARK: - Constants

fileprivate struct Constants {
    private init() {}
    
    static let errorMessage = "Oops! Something went wrong..."
}
