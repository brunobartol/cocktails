import Combine
import SwiftUI

final class CocktailDetailsVM: ObservableObject {
    struct ViewState {
        var isLoading = true
        var cocktail: CocktailDetailsModel?
        var errorMessage: String?
    }
    
    @Published var state: ViewState = ViewState()
    
    private let id: String
    private let service: CocktailDetailsServiceProtocol
    private(set) var cancellables = Set<AnyCancellable>()
    
    private lazy var parseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.parseDateFormat
        return formatter
    }()
    
    private lazy var displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.displayDateFormat
        return formatter
    }()
    
    init(id: String, service: CocktailDetailsServiceProtocol) {
        self.id = id
        self.service = service
        
        fetchData(id)
    }
    
    private func fetchData(_ id: String) {
        service.fetchCocktailDetails(id)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                state.isLoading = false
                
                switch completion {
                case .finished:
                    ()
                case .failure(_):
                    state.cocktail = nil
                    state.errorMessage = Constants.errorMessage
                }
            } receiveValue: { [weak self] dto in
                self?.state.cocktail = CocktailDetailsModel(from: dto)
                self?.state.errorMessage = nil
            }
            .store(in: &cancellables)
    }
    
    func formatDate() -> String? {
        guard
            let cocktail = state.cocktail,
            let dateString = cocktail.dateModified,
            let date = parseDateFormatter.date(from: dateString) else {
            return nil
        }
        
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month], from: Date())
        let dateComponents = calendar.dateComponents([.year, .month], from: date)
        let isInThisMonth = currentDateComponents.year == dateComponents.year && currentDateComponents.month == dateComponents.month
        
        return isInThisMonth ? Constants.thisMonthDate : displayDateFormatter.string(from: date)
    }
}

fileprivate struct Constants {
    private init() {}
    
    static let errorMessage = "Oops! Something went wrong..."
    static let thisMonthDate = "This month"
    static let parseDateFormat: String = "yyyy-MM-dd HH:mm:ss"
    static let displayDateFormat: String = "dd-MM-yyyy"
}
