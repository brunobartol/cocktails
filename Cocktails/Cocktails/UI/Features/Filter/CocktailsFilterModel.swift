enum FilterType: CaseIterable {
    case category
    case glass
    case alcoholicType
}

struct Filter: Identifiable {
    let id: String
    let type: FilterType
    let value: String
    
    init(type: FilterType, value: String) {
        self.type = type
        self.value = value
        
        self.id = "\(value)#\(type)#"
    }
}

struct CocktailsFilterModel {
    let allFilters: [Filter]
    let filteredSearch: [Filter]
    
    var categories: [Filter] {
        allFilters.filter { $0.type == .category }
    }
    
    var glasses: [Filter] {
        allFilters.filter { $0.type == .glass }
    }
    
    var alcoholicTypes: [Filter] {
        allFilters.filter { $0.type == .alcoholicType }
    }
    
    init(allFilters: [Filter], filteredSearch: [Filter]) {
        self.allFilters = allFilters
        self.filteredSearch = filteredSearch
    }
}
