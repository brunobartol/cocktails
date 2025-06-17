enum Endpoint {
    case cocktalisList(_ query: String)
    case cocktailDetails(_ id: String)
    case randomCocktail
    
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
        }
    }
    
    var url: String {
        "\(baseURL)\(endpointURL)"
    }
}
