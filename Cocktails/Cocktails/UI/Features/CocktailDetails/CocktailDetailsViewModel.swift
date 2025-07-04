import Combine
import SwiftUI

final class CocktailDetailsViewModel: ObservableObject {
    enum ViewState {
        case loading
        case success(cocktail: CocktailDetailsModel)
        case error(message: String)
    }
    
    @Published var state: ViewState = .loading
    
    private let id: String
    private let service: CocktailDetailsServiceProtocol
    private(set) var cancellables = Set<AnyCancellable>()
    
    init(id: String, service: CocktailDetailsServiceProtocol) {
        self.id = id
        self.service = service
        
        fetchData()
    }
    
    private func fetchData() {
        service.fetchCocktailDetails(id)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    ()
                case .failure(_):
                    state = .error(message: Constants.errorMessage)
                }
            } receiveValue: { [weak self] dto in
                guard let self else { return }
                
                state = .success(cocktail: CocktailDetailsModel(from: dto))
            }
            .store(in: &cancellables)
    }
}

// MARK: - Constants -

fileprivate enum Constants {
    static let errorMessage = "Oops! Something went wrong..."
}
