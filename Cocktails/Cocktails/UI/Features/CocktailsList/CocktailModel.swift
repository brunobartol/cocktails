struct CocktailModel: Identifiable {
    let id: String
    let imageUrl: String
    let title: String
    let ingredients: String?
    let category: String
    let alcoholic: String
}

extension CocktailModel {
    init(from dto: CocktailDTO) {
        self.id = dto.id
        self.imageUrl = dto.imageUrl
        self.title = dto.name
        self.ingredients = dto.ingredients
        self.category = dto.category
        self.alcoholic = dto.alcoholic
    }
}
