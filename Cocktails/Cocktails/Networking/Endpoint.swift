import Foundation

enum Endpoint {
    case cocktalisList(_ query: String)
    case cocktailDetails(_ id: String)
    case randomCocktail
    case categoryFilterList
    case glassFilterList
    case alcoholicTypeFilterList
    case filter(category: String?, glass: String?, alcoholicType: String?)
    
    private var baseURL: String {
        "https://www.thecocktaildb.com/api/json/v1/1/"
    }
    
    private var endpointURL: String {
        switch self {
        case .cocktalisList(let query):
            "search.php?s=\(query)"
        case .cocktailDetails(let id):
            "lookup.php?i=\(id)"
        case .randomCocktail:
            "random.php"
        case .categoryFilterList:
            "list.php?c=list"
        case .glassFilterList:
            "list.php?g=list"
        case .alcoholicTypeFilterList:
            "list.php?a=list"
        case .filter(let category, let glass, let alcoholicType):
            "filter.php" + (withFilterComponents(category: category, glass: glass, alcoholicType: alcoholicType))
        }
    }
    
    var url: String {
        "\(baseURL)\(endpointURL)"
    }
    
    private func withFilterComponents(category: String?, glass: String?, alcoholicType: String?) -> String {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "c", value: category),
            URLQueryItem(name: "g", value: glass),
            URLQueryItem(name: "a", value: alcoholicType),
        ]
        
        guard let query = components.url else {
            return ""
        }
        
        return query.absoluteString
    }
}
