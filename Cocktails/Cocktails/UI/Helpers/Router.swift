import SwiftUI

final class Router: ObservableObject {
    enum Route {
        case cocktailList
        case cocktailDetails(_ id: String)
        case filter
        case filteredCocktailList(_ filteredIds: [String])
    }
    
    @Published private(set) var currentRoute: Route = .cocktailList
    
    init() {}
    
    func navigate(to route: Route) {
        currentRoute = route
    }
}
